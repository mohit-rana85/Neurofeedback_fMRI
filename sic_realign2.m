function handles=sic_realign2(handles)
try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  if handles.b.pre.realign_opt.rtm,
%     count = ones(size(b));
%     ave   = G;
%     grad1 = dG1;
%     grad2 = dG2;
%     grad3 = dG3;
% end;
    V  = smooth_vol(handles.b.current_volume.V,handles.b.pre.realign_opt.interp,handles.b.pre.realign_opt.wrap,handles.b.pre.realign_opt.fwhm);
    d  = [size(V) 1 1];
    d  = d(1:3);
    ss = Inf;
    countdown = -1;

    for iter=1:64,
        [y1,y2,y3] = coords([0 0 0  0 0 0],handles.b.pre.normalization.ref_file_vol_data.mat,handles.b.current_volume.V.mat,handles.b.pre.normalization.x1,handles.b.pre.normalization.x2,handles.b.pre.normalization.x3);
        msk        = find((y1>=1 & y1<=d(1) & y2>=1 & y2<=d(2) & y3>=1 & y3<=d(3)));
        if length(msk)<32, error_message(handles.b.current_volume.V); end;
        
        F          = spm_bsplins(V, y1(msk),y2(msk),y3(msk),handles.b.pre.normalization.deg);
        if ~isempty(handles.b.pre.normalization.wt), F = F.*handles.b.pre.normalization.wt(msk); end;
        
        A          = handles.b.pre.normalization.A0(msk,:);
        b1         = handles.b.pre.normalization.b(msk);
        sc         = sum(b1)/sum(F);
        b1         = b1-F*sc;
        soln       = (A'*A)\(A'*b1);
        
        p          = [0 0 0  0 0 0  1 1 1  0 0 0];
        p(handles.b.pre.normalization.lkp)     = p(handles.b.pre.normalization.lkp) + soln';
        handles.b.current_volume.V.mat   = inv(spm_matrix(p))*handles.b.current_volume.V.mat;
        
        pss        = ss;
        ss         = sum(b1.^2)/length(b1);
        if (pss-ss)/pss < 1e-8 && countdown == -1, % Stopped converging.
            countdown = 0;
        end;
        if countdown ~= -1,
            if countdown==0, break; end;
            countdown = countdown -1;
        end;
    end;
  aa=  spm_imatrix(handles.b.current_volume.V.mat/handles.b.pre.normalization.ref_file_vol_data.mat);
handles.b.current_volume.para=aa(1,1:6);
%     if handles.b.pre.realign_opt.rtm,
%         % Generate mean and derivatives of mean
%         tiny = 5e-2; % From spm_vol_utils.c
%         msk        = find((y1>=(1-tiny) & y1<=(d(1)+tiny) &...
%             y2>=(1-tiny) & y2<=(d(2)+tiny) &...
%             y3>=(1-tiny) & y3<=(d(3)+tiny)));
%         count(msk) = count(msk) + 1;
%         [G,dG1,dG2,dG3] = spm_bsplins(V,y1(msk),y2(msk),y3(msk),deg);
%         ave(msk)   = ave(msk)   +   G*sc;
%         grad1(msk) = grad1(msk) + dG1*sc;
%         grad2(msk) = grad2(msk) + dG2*sc;
%         grad3(msk) = grad3(msk) + dG3*sc;
%     end;
    %spm_progress_bar('Set',i-1);

catch ME
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack.line),' in ', ME.stack.name,': ',ME.message];
    set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    
end

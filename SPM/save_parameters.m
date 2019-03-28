function [Q]=save_parameters(V)
%fname = [spm_str_manip(prepend(V(1).fname,'rp_'),'s') '.txt'];
% n = length(V);
% Q = zeros(n,6);
% for j=1:n,
    qq     = spm_imatrix(V(2).mat/V(1).mat);
    Q = qq(1:6);
% end;
%save(fname,'Q','-ascii');

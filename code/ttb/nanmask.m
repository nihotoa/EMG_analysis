function y  = nanmask(x,mask)
% y  = nanmask(x,mask)
% mask��x�Ɠ����T�C�Y��logical(or1/0)�s��i�z��j
% mask��0�̗v�f��NaN�ɂ���������


warning('off')
mask    = double(mask) ./ double(mask);
y       = x .* mask;
warning('on')
function [DC,phi]    = dcoh(Hf,Sf,F,method)
% DCOH Directed coherence.
%     [dcoh,phi]    = dcoh(Hf,Sf,F,opt)
%     Input
%      Hf     Transfer function matrix depending on frequency made by dtransf
%             (ex) Hf(1,2,:) indicates transfer function of signal 2 => signal 1. (see ref.[2] eq.(5))
%      Sf     Cross-spectral density matrix depending on frequency  made by dtransf
%             (ex) Sf(1,2,:) indicates Cross-spectrum between signal 1 and  signal 2. (see ref.[2] eq.(1))
%      F      Frequency vector specifying the frequcency of Hf and Sf.
%      opt    normalization method; 'Kaminski', 'Baker' or 'none'
% 
%     Output
%      dcoh,phi   
%
% References
% [1] Kamiski MJ, Blinowska KJ "A new method of the description of the information flow in the brain structures." Biol Cybern  1991-v65-pp203-10  
% [2] Baccal LA, Sameshima K "Partial directed coherence: a new concept in neural structure determination." Biol Cybern  2001-v84-pp463-74  
% [3] Baker SN, Chiu M, Fetz EE "Afferent encoding of central oscillations in the monkey arm." J Neurophysiol  2006-v95-pp3904-10 

% written by TT 070130
k   = size(Hf); % k channels

DC  = zeros(size(Hf));

switch lower(method(1))
    case ('k')
        % This is called as directed transfer function (DTF) ...ref[1](7)
        % It is ranging 0 - 1 
%         disp('Kaminski method')
        for ii=1:k
            sumrow = squeeze( sum( abs( Hf(ii,:,:) ).^2,2) );
            for jj=1:k
                DC(ii,jj,:)   =  sqrt(squeeze(abs(Hf(ii,jj,:)).^2) ./ sumrow );
            end
        end
        
    case ('b')
%         disp('Baker method')
        for ii=1:k
            for jj=1:k
                DC(ii,jj,:)   =  squeeze( (abs(Hf(ii,jj,:)).^2) .* real(Sf(jj,jj,:)) ./ real(Sf(ii,ii,:)) );
            end
        end
    case ('n')
        DC  = abs(Hf).^2;
end

phi         = angle(Hf);
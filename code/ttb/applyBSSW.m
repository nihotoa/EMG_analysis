function X  = applyBSSW(W,X)

[nX,nsig]   = size(X);
% Y   = zeros(size(X));

% Generate the outputs from X and W, without post-separation process
Y   = gen_y(W,X);

disp('gen_y')

% Crosscorrelate all input signals with all possible output signals.
% Assign output indices to input indices based on maximum absolute
% correlation values between input and output signals.

R = zeros(nsig, nsig); % Best correlations values between inputs and outputs.
S = zeros(nsig, nsig); % Scale factor for the output.
for outputIndex = 1:nsig
%    waitbar(OBJ_WAITBAR, 'update', (3 + outputIndex/nsig) / 4, ['Source matching for channel ' num2str(outputIndex) ' of ' num2str(nsig)]);
%    applynow;
   Ysep = y2y(W, Y, outputIndex); % Use post-separation process to generate possible outputs.
%    for isig = 1:nsig
      % Correlate original input signals with output signals.
      for inputIndex = 1:nsig
         rvals = corrcoef(X(:,inputIndex), Ysep(:,inputIndex));
         rval = rvals(1,2);
         if abs(rval) > R(inputIndex,outputIndex)
            R(inputIndex,outputIndex) = abs(rval);
            S(inputIndex,outputIndex) = sign(rval) * std(X(:, inputIndex)) / std(Ysep(:, inputIndex));
         end
      end
%    end
end

[maxval, outputIndex] = max(R,[], 2);
for isig =1:nsig
    Ysep    = y2y(W, Y, outputIndex(isig));
%     X(:,isig)   = Ysep(:,isig) * S(isig,outputIndex(isig));
    X(:,isig)   = Ysep(:,isig);
    disp(['y2y',num2str(isig),' outputIndex=',num2str(outputIndex(isig)),' R=',num2str(R(isig,outputIndex(isig))),' S=',num2str(S(isig,outputIndex(isig)))]);
end

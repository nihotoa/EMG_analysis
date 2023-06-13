function dispremainhr(ii,nAna,Outputfile)
try
        elaspsec   = toc;
        remainhr    = (elaspsec / ii * (nAna - ii) / 3600);
        message     = sprintf('Time remaining: %2f hr %d/%d -> %s',remainhr,ii,nAna,Outputfile);
        disp(message);
catch
    keyboard
end
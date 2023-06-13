function	[check_err, test_err] = get_check_err(InfoStat)

CheckErr = InfoStat.CheckErr;
TestErr  = InfoStat.TestErr ;

Nact = InfoStat.Nact;
Xdim = InfoStat.Xdim;
Nall = length(Nact) + 1;

% Add first & last value
CheckErr = [CheckErr(1); CheckErr; CheckErr(end)];
TestErr  = [TestErr(1);  TestErr;  TestErr(end)] ;
Nact     = [1; Nact; Xdim];

check_err = zeros(Xdim,1);
test_err  = zeros(Xdim,1);

for n=1:Nall
	ix = Nact(n):Nact(n+1);
	N  = Nact(n+1) - Nact(n);
	
	if N == 0,
		x = 0;
	else
		x  = (0:N)/N;
	end
	
	check_err(ix) = (CheckErr(n+1) - CheckErr(n)) * x + CheckErr(n);
	test_err(ix)  = (TestErr(n+1) - TestErr(n)) * x + TestErr(n);
end

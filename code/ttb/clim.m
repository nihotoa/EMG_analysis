function a = clim(arg1, arg2)
%CLIM C limits.
%   CL = CLIM             gets the c limits of the current axes.
%   CLIM([CMIN CMAX])     sets the c limits.
%   CLMODE = CLIM('mode') gets the c limits mode.
%   CLIM(mode)            sets the c limits mode.
%                            (mode can be 'auto' or 'manual')
%   CLIM(AX,...)          uses axes AX instead of current axes.
%
%   CLIM sets or gets the CLim or CLimMode propertc of an axes.
%
%   See also PBASPECT, DASPECT, XLIM, ZLIM.
 
%   Copyright 1984-2005 The MathWorks, Inc. 
%   $Revision: 1.7.4.2 $  $Date: 2005/10/28 15:53:29 $

if nargin == 0
  a = get(gca,'clim');
else
  if isscalar(arg1) && ishandle(arg1) && strcmp(get(arg1, 'type'), 'axes')
    ax = arg1;
    if nargin==2
      val = arg2;
    else
      a = get(ax,'clim');
      return
    end
  else
    if nargin==2
      error('MATLAB:clim:InvalidNumberArguments', 'Wrong number of arguments')
    else
      ax = gca;
      val = arg1;
    end
  end
    
  if ischar(val)
    if(strcmp(val,'mode'))
      a = get(ax,'climmode');
    else
      set(ax,'climmode',val);
    end
  else
    set(ax,'clim',val);
  end
end

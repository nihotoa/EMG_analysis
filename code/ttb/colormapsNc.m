% ColormapsNc lets you create your own colormaps (up to 256 colors).
% ColormapsNc is able to create a custom colormap by specifying up to 256 different
% colors. The colors will be shown in the order you chose them
% from the botton to the top of the colorbar.
% If you execute this program after that a figure with your own data has been
% generated, the ColormapsNc will apply automatically the new colormap
% generating a new colorbar.
% This program is an upgrade of the COLORMAPS3C program written by me.
% See also COLORBAR, COLORMAP.

%   Danilo Botta 30-05-04


echo off;
nc=256;

cns='2';
sc=2;

while sc==2,
   def= {cns};
   prompt={'Number of colors ='};
   tit1='Select the number of colors for your colormap.';
   lines=1;
   alfain=inputdlg(prompt,tit1,lines,def);
   n=(str2num(alfain{1}));
   nx=round(nc/(n-1));
   cns=alfain{1};
   sc=1;
   clear special; 
   special=[];
  
   
   while sc==1,
      A=uisetcolor([0 0 0], 'Select color 1:');
      
      for index=1:n-1,
         clear B;
         
         tx=['Select color ',num2str(index+1),':'];
         B=uisetcolor([0 0 0], tx);
         
         clear C1;
         C1=(B-A);
         
         nin=(1+nx*(index-1));
         
         if index==n-1,
            nfin=256;
         else
            nfin=(nx*index);
         end
         
         ninc=nfin-nin;
         
         for i=nin:nfin,
            special(i,:)=[(A(1,1)+(C1(1,1)*(i-nin))/ninc) (A(1,2)+(C1(1,2)*(i-nin))/ninc) (A(1,3)+(C1(1,3)*(i-nin))/ninc)];
         end    
         
         clear A;
         A=B;
         
      end
      
      colormap(special);
      
      colorbar;
      
      clear sc;
      
      sc=menu('Do you wish to repeat ColormapsNc?', 'Repeat', 'Change the number of colors','End');
      
   end
end

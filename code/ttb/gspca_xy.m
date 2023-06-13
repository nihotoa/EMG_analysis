function gspca_xy
global gsobj
h   = gsobj.handles.pca;

prompt = {'X-axis:','Y-axis:'};
dlg_title = 'Select for PCA plot';
num_lines = 1;
def = {'1','2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

gsobj.pca.x = str2num(answer{1});
gsobj.pca.y = str2num(answer{2});

xlabel(h,['PCA',answer{1}])
ylabel(h,['PCA',answer{2}])

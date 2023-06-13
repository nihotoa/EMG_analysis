function hAx    = uiSelectAxis

fig = gcf;
figure(fig);
old_pointer = get(fig,'Pointer');
set(fig,'Pointer','circle');

waitforbuttonpress;

set(fig,'Pointer',old_pointer);
hAx = gca;
function baseball
figure('KeyPressFcn',@keypress)

function keypress(src,evnt)

if isempty(evnt.Modifier)
    switch evnt.Key
        case 'space'
            disp('takei')
    end
end
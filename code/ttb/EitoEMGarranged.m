function y = EitoEMGarranged(type)
% 'FDI' %
% 'ADP' %
% 'AbPB' %
% '2DI' %
% '3DI' %
% '4DI' %
% 'AbDM' %
% 'FDS' %
% 'FDPr' %
% 'FDPu' %
% 'AbPL' %
% 'ED23' %
% 'EDC' %
% 'FCR' %
% 'FCU' %
% 'PL' %
% 'ECR' %
% 'ECU' %
% 'BRD' %
% 'Biceps' %
% 'Triceps' %

if nargin<1
    type    = 'all';
end

switch type
    case 'none'
        y=  {'FDI'
            'ADP'
            'AbPB'
            '2DI'
            '3DI'
            '4DI'
            'AbDM'
            'FDS'
            'FDPr'
            'FDPu'
            'AbPL'
            'ED23'
            'EDC'
            'FCR'
            'FCU'
            'PL'
            'ECR'
            'ECU'
            'BRD'
            'Biceps'
            'Triceps'};
    case 'all'

        y=  {'FDI'
            'ADP'
            'AbPB'
            '2DI'
            '3DI'
            '4DI'
            'AbDM'
            'FDS'
            'FDPr'
            'FDPu'
            'AbPL'
            'ED23'
            'EDC'
            'FCR'
            'FCU'
            'PL'
            'ECR'
            'ECU'
            'BRD'
            'Biceps'
            'Triceps'
            'STA (Spike, lFDIl(uV))'
            'STA (Spike, lADPl(uV))'
            'STA (Spike, lAbPBl(uV))'
            'STA (Spike, l2DIl(uV))'
            'STA (Spike, l3DIl(uV))'
            'STA (Spike, l4DIl(uV))'
            'STA (Spike, lAbDMl(uV))'
            'STA (Spike, lFDSl(uV))'
            'STA (Spike, lFDPrl(uV))'
            'STA (Spike, lFDPul(uV))'
            'STA (Spike, lAbPLl(uV))'
            'STA (Spike, lED23l(uV))'
            'STA (Spike, lEDCl(uV))'
            'STA (Spike, lFCRl(uV))'
            'STA (Spike, lFCUl(uV))'
            'STA (Spike, lPLl(uV))'
            'STA (Spike, lECRl(uV))'
            'STA (Spike, lECUl(uV))'
            'STA (Spike, lBRDl(uV))'
            'STA (Spike, lBicepsl(uV))'
            'STA (Spike, lTricepsl(uV))'
            'STA (Grip Onset (svwostim), lFDIl(uV))'
            'STA (Grip Onset (svwostim), lADPl(uV))'
            'STA (Grip Onset (svwostim), lAbPBl(uV))'
            'STA (Grip Onset (svwostim), l2DIl(uV))'
            'STA (Grip Onset (svwostim), l3DIl(uV))'
            'STA (Grip Onset (svwostim), l4DIl(uV))'
            'STA (Grip Onset (svwostim), lAbDMl(uV))'
            'STA (Grip Onset (svwostim), lFDSl(uV))'
            'STA (Grip Onset (svwostim), lFDPrl(uV))'
            'STA (Grip Onset (svwostim), lFDPul(uV))'
            'STA (Grip Onset (svwostim), lAbPLl(uV))'
            'STA (Grip Onset (svwostim), lED23l(uV))'
            'STA (Grip Onset (svwostim), lEDCl(uV))'
            'STA (Grip Onset (svwostim), lFCRl(uV))'
            'STA (Grip Onset (svwostim), lFCUl(uV))'
            'STA (Grip Onset (svwostim), lPLl(uV))'
            'STA (Grip Onset (svwostim), lECRl(uV))'
            'STA (Grip Onset (svwostim), lECUl(uV))'
            'STA (Grip Onset (svwostim), lBRDl(uV))'
            'STA (Grip Onset (svwostim), lBicepsl(uV))'
            'STA (Grip Onset (svwostim), lTricepsl(uV))'};
end



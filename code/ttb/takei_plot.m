function takei_plot
% takei_plot
% 
% ����@nips���쐬���������f�[�^��\������A�P���ȃv���O�����ł��B
% �܂��́ADVD��DVD�h���C�u�ɓ��ꂽ��ԁi��������DVD���̃f�[�^�����[�J���f�B�X�N�ɕۑ�������ԁj��
% 
% takei_plot
% 
% �����s���Ă��������B
% ���̌�A�t�@�C���I���_�C�A���O������܂��̂ŁA�C�ӂ�mat�t�@�C����I�����Ă��������B
% �V����figure��ɁA�f�[�^�i�f�t�H���g�ł͍ŏ���60�b�ԁj���`�悳��܂��B

% 28/Nov/2008 T.Takei



% �`�悷�鎞�Ԓ��i�b�j
t       = 60;   % in sec

% �t�@�C���̑I��
[filename,pathname] = uigetfile('*.mat','�J�������t�@�C�����ЂƂI�����Ă��������B');
fullfilename        = fullfile(pathname,filename);

% �t�@�C���̓ǂݍ���
load(fullfilename);

% ���Ԏ��̐ݒ�
XData   = ([0:(length(Data)-1)]./SampleRate) + TimeRange(1);
ind     = 1:SampleRate*t;

% �`��
figure;
plot(XData(ind),Data(ind))
xlabel('Time (Sec)')
ylabel('Amplitude')
title(Name)




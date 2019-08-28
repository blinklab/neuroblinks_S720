function InitCam(ch,recdur)

% First delete any existing image acquisition objects
imaqreset

disp('Creating video object ...')
vidobj = videoinput('gentl', 1, 'Mono8');


metadata=getappdata(0,'metadata');
src = getselectedsource(vidobj);
src.ExposureTime = metadata.cam.init_ExposureTime;
src.AcquisitionFrameRateMode='Basic'; %must be set to basic to change frame rate later
% src.AllGain=12;				% Tweak this based on IR light illumination (lower values preferred due to less noise)
% src.StreamBytesPerSecond=124e6; % Set based on AVT's suggestion
% src.StreamBytesPerSecond=80e6; % Set based on AVT's suggestion

% src.PacketSize = 9014;		% Use Jumbo packets (ethernet card must support them) -- apparently not supported in VIMBA
% src.PacketSize = 8228;		% Use Jumbo packets (ethernet card must support them) -- apparently not supported in VIMBA
% src.PacketDelay = 2000;		% Calculated based on frame rate and image size using Mathworks helper function
vidobj.LoggingMode = 'memory'; 
src.AcquisitionFrameRate=200.000080000032; %%exactly 200 not available, camera auto switches to this value
% vidobj.Fr

FramesPerTrigger=ceil(recdur/(1000/200));
% vidobj.FramesPerTrigger=20;
% vidobj.FramesPerTrigger=ceil(recdur/(1000/49.7604));
vidobj.FramesPerTrigger=FramesPerTrigger;

% triggerconfig(vidobj, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
% set(src,'AcquisitionStartTriggerMode','on')
% set(src,'FrameStartTriggerSource','Freerun')
% set(src,'AcquisitionStartTriggerActivation','RisingEdge')

triggerconfig(vidobj, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
% src.FrameStartTriggerActivation = 'LevelHigh';
src.TriggerActivation = 'LevelHigh';
% This needs to be toggled to switch between preview and acquisition mode
% It is changed to 'Line0' in MainWindow just before triggering Arduino and then
% back to 'Software' in 'endOfTrial' function
% src.FrameStartTriggerSource = 'Line1';
src.TriggerSource = 'Line0';
src.TriggerMode='Off';
% src.TriggerMode='On';
% src.TriggerSelector='FrameStart';
src.TriggerSelector='AcquisitionStart';
% src.TriggerSource='Freerun';

%% Save objects to root app data
setappdata(0,'vidobj',vidobj)
setappdata(0,'src',src)

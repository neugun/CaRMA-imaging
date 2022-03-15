% Example of using CaptureFigVid
% Cheers, Dr. Alan Jennings, Research assistant professor, 
% Department of Aeronautics and Astronautics, Air Force Institute of Technology

%% Set up 3D plot to record
figure(171);clf;
surf(peaks,'EdgeColor','none','FaceColor','interp','FaceLighting','phong')
daspect([1,1,.3]);axis tight;

%% Set up recording parameters (optional), and record
OptionZ.FrameRate=30;OptionZ.Duration=30;OptionZ.Periodic=true;
CaptureFigVid([-20,30;160,30;340,30;340,210;340,390,], 'Mat_3d',OptionZ)

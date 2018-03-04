clear all;
close all;
clear cache;
clc;

global nCh collectionInterval samplingRate windowCoff isCollecting doubleTap MyoDataSize buffer;

nCh = 8;
MyoDataSize = 50;
isCollecting = 1;    %   
samplingRate  = 200; % Myo sampling frequency
windowCoff    = 2;   % how long a letter performed in sec
collectionInterval = samplingRate*windowCoff; % Raw Data buffer size collectionInterval = sampleingRate * timeTo buffer in seconds

%% for real time experiment
doubleTap = 0;     % double tap first tap 1 second tap 0 

%% Setting up a Timer for a background process for Collecting MYO EMG Data (Control)
t=timer;
t.StartFcn       = @socket_start_Func;
t.Period         = 0.15; 
t.StartDelay     = 2;
t.StopFcn        = @socket_stop_Func;
t.TimerFcn       = @socket_read_Func;  
t.TasksToExecute = inf; 
t.ExecutionMode  = 'fixedSpacing';
start(t);

%% Try catch should be here  
nClass = 2; 
iter = 5;
try
    pause(2)
    for i=1:nClass
        for j=1:iter
            pause(500/1000)
            sprintf('Please perform %d',i)
            pause(1800/1000)

            index = iter*(i-1) + j;
            Data_Akash(index).start=clock();
            Data_Akash(index).emg = (buffer);
            Data_Akash(index).label = i;
            Data_Akash(index).stop=clock();
            disp('done')
            pause(300/1000)
        end
    end

catch
    stop(t);
    delete(t);
end
%% Stop experiment
%pause();

%% Stop timer and delete it.
stop(t);
delete(t);
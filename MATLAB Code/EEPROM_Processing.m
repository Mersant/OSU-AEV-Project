%=============================================
% Name: David Lowry, Drew Reed, Megan Smith
% Date: 03/09/2022
% Class: ENGR 1182
% Program Title: EEPROM Data Processor
%
% Program Description: Processes EEPROM data in any excel sheet format so
% long as the columns retain their names. This will allow for modification
% of the original file without breaking the EEPROM processor. The program
% simply performs several unit conversions and can generate graphs
% when desired.
%=============================================
clear;clc;close all;
fprintf('Welcome to the EEPROM Data Processor\n');

fprintf('Enter filename for Excel file...\n\n');
[LoadFile,LoadPath] = uigetfile('*.xlsx','Enter filename for Excel file');
fprintf('Enter filename to save output to...\n\n');
[SaveFile,SavePath]=uiputfile('*.xlsx','Enter filename for Excel file');

SaveFileName = [SavePath SaveFile];
if LoadFile == 0 
    clc
    return
end
FileName = [LoadPath LoadFile];
[num,text,OutData] = xlsread(FileName);
% Process data, see arguments for unit conversions. . .
[OutData, Time] = Process(OutData,' Time (ms) ',' Time (s) ','X./1000'); 
OutData = deal(Process(OutData,' Current (counts) ',' Current (A) ', ...
    '(X./1024).*2.46.*(1/0.185)'));
OutData = deal(Process(OutData,' Voltage (counts) ',' Voltage (V) ', ...
    '(15.*X)./1024'));
[OutData, Distance] = Process(OutData,' Marks (Cumulative wheel counts) ', ...
    ' Distance (m) ','X.*0.0124');
OutData = Process(OutData,' Marks (Position wheel counts) ', ...
    ' Relative Position (m) ','X.*0.0124');
[OutData, Power] = Process(OutData,' Current (A) ',' Supplied Power (W) ','X.*Y', ...
    ' Voltage (V) '); % Supplied Power(W) = Current(A) * Voltage(V)
% Calculate incremental energy
for i=1:length(Power)-1
    IncEnergy(i) = (( Power(i) + Power(i+1) )/2)*( Time(i+1) - Time(i) );
end
OutData = PasteData(OutData,' Incremental Energy (J) ',num2cell(IncEnergy));
% Total energy
for i=1:length(IncEnergy)
    TotalEnergy(i) = sum(IncEnergy(:,1:i));
end
OutData = PasteData(OutData,' Total Energy (J) ',num2cell(TotalEnergy));
% Velocity
for i=2:length(Distance)
    Vel(i) = ( Distance(i) - Distance(i-1) ) / ( Time(i) - Time(i-1) );
end
OutData = PasteData(OutData,' Velocity (m/s) ',num2cell(Vel));
% Kinetic energy, I am assuming AEV weighs 1 kg since I do not know the
% actual weight.
Mass = 1;
OutData = Process(OutData,' Velocity (m/s) ',' Kinetic Energy (J) ','X.^2 .*0.5');

OutData = Process(OutData,' Current (A) ',' Propeller RPM ', ...
    '0.8*(-64.59*X.^2 + 1927.25*X - 84.58)');
[OutData,J] = Process(OutData,' Propeller RPM ',' Propeller Advance Ratio ', ...
    'Y./( (X./60) * 0.0809625 )',' Velocity (m/s) ');
% Filter advance ratio
for i=1:length(J)
    if J(i) <= 0.15
        if Power(i) > 0.5 % If the motors are running
            J(i) = 0.15;
        else
            J(i) = 0;
        end
    end
end
OutData = PasteData(OutData,' Propeller Advance Ratio ',num2cell(J));
[OutData,E] = Process(OutData,' Propeller Advance Ratio ',' Propulsion Efficiency ', ...
    '-454.37 * X.^3 + 321.58 * X.^2 + 22.603 * X');

writecell(OutData,SaveFileName)
inp = input('Program finished, graph? (Y/N) ','s');
if lower(inp) == 'n'
    return
end

clc;
fprintf('--------------- Graph Options ---------------\n');
fprintf('| 1. Watts      vs. time                    |\n');
fprintf('| 2. Watts      vs. Distance                |\n');
fprintf('| 3. Speed      vs. Distance                |\n');
fprintf('| 4. Energy     vs. Distance                |\n');
fprintf('| 5. Efficiency vs. Distance                |\n');
fprintf('| 6. All                                    |\n');
fprintf('---------------------------------------------\n');
inp = input('Option? #','s');

%Half-Track run:
%PhaseTimings = [0 2.1 5 8.9 12 12.75 16.5 17 19.2 22.1 24.84 24.9 25.02 25.62];

%PhaseTimings = [0 4.62 6.48 9.06 11.04 24.843]; % <--MotorSpeed run
PhaseTimings = [0 9.06 10.68 17.1]; % <-- Celerate run
if inp=='1' || inp=='6'
    plot(Time,Power);
    xlabel('Time (s)');
    ylabel('Power (Watts)');
    title('Power consumption as time varies');
    grid on;
 
    for i=2:length(PhaseTimings)
        xR = PhaseTimings(i);
        xL = PhaseTimings(i-1);
        iL = knnsearch(Time,xL);
        iR = knnsearch(Time, xR);
        Temp = Power(iL:iR);
        EnergyPhasesPvT(i-1) = sum(Temp);
    end
end

if inp=='2' || inp=='6'
    figure;
    plot(Time,Distance);
    xlabel('Time (s)');
    ylabel('Distance (m)');
    grid on;

    for i=2:length(PhaseTimings)
        xR = PhaseTimings(i);
        xL = PhaseTimings(i-1);
        iL = knnsearch(Time,xL);
        iR = knnsearch(Time, xR);
        Temp = Power(iL:iR);
        EnergyPhasesPvD(i-1) = sum(Temp);
    end
end
    
if inp=='3' || inp=='6'
    figure;
    plot(Distance,Vel);
    xlabel('Distance (m)');
    ylabel('Speed (m/s)');
    grid on;
end

if inp=='4' || inp=='6'
    figure;
    plot(Distance(1:end-1),IncEnergy);
    xlabel('Distance (m)');
    ylabel('Incremental Energy (Joules)');
    grid on;
end

if inp=='5' || inp=='6'
    figure;
    plot(Distance,E);
    xlabel('Distance (m)');
    ylabel('Efficiency (%)');
    ylim([0 100]);
    grid on;
end



























  


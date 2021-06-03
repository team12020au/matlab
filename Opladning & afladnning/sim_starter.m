close all; clear;
%Settings values to 0 as a default
LoadSaltVand = 0;
SaltVandON = 0;
SwitchCurrentSaltVand = 0;
CurrentChargeSaltVand = 0;
VoltageChargeSaltVand = 0;
LoadBlySyre = 0;
BlySyreON = 0;
SwitchCurrentBlySyre = 0;
CurrentChargeBlySyre = 0;
VoltageChargeBlySyre = 0;
LoadNiMH = 0;
NiMHON = 0;
SwitchCurrentNiMH = 0;
CurrentChargeNiMH = 0;
VoltageChargeNiMH = 0;
LoadLiStor = 0;
LiIonStorON = 0;
SwitchCurrentLiStor = 0;
CurrentChargeLiStor = 0;
VoltageChargeLiStor = 0;
LoadLille = 0;
LiIonLilleON = 0;
SwitchCurrentLiLille = 0;
CurrentChargeLiLille = 0;
VoltageChargeLiLille = 0;


opstilling = readtable('/Users/jenslawl/Documents/Centos/matlab.csv');
charge_or_discharge = table2array(opstilling(1,2));
batType = table2array(opstilling(1,1));
load = table2array(opstilling(1,3));
voltage_current = table2array(opstilling(1,4));
sim_length = table2array(opstilling(1,5 ));

%If we have a discharge
if (charge_or_discharge == 0)
    if(batType == "s")
       SaltVandON = 1;
       LoadSaltVand = load;
    elseif (batType == "b")
        BlySyreON = 1;
        LoadBlySyre = load;
    elseif (batType == "n")
        NiMHON = 1;
        LoadNiMH = load;
    elseif (batType == "lis")
        LiIonStorON = 1;
        LoadLiSTOR = load;
    elseif (batType == "lil")
        LiIonLilleON = 1;
        LoadLille = load;
    end
   out = sim('Full_load_sim_doc.slx', sim_length);
end

%If we have to charge. 
if (charge_or_discharge == 1)
    if(voltage_current == "c")
        if(batType == "s")
           SaltVandON = 1;
           SwitchCurrentSaltVand = 1;
           CurrentChargeSaltVand = load;
        elseif (batType == "b")
           BlySyreON = 1;
           SwitchCurrentBlySyre = 1;
           CurrentChargeBlySyre = load;
        elseif (batType == "n")
           NiMHON = 1;
           SwitchCurrentNiMH = 1;
           CurrentChargeNiMH = load;
        elseif (batType == "lis")
           LiIonStorON = 1;
           SwitchCurrentLiStor = 1;
           CurrentChargeLiStor = load;
        elseif (batType == "lil")
           LiIonLilleON = 1;
           SwitchCurrentLiLille = 1;
           CurrentChargeLiLille = load;
        end
    elseif(voltage_current == "v")
        if(batType == "s")
           SaltVandON = 1;
           VoltageChargeSaltVand = load;
        elseif (batType == "b")
           BlySyreON = 1;
           VoltageChargeBLySyre = load;
        elseif (batType == "n")
           NiMHON = 1;
           VoltageChargeNiMH = load;
        elseif (batType == "lis")
           LiIonStorON = 1;
           VoltageChargeLiStor = load;
        elseif (batType == "lil")
           LiIonLilleON = 1;
           VoltageChargeLiLille = load;
        end
    end
   out = sim('Full_Charge.slx', sim_length);
end

%Output value to ensure we don't send to much data to the cloud
if (batType == "s")
    v = out.voltageSaltVand;
    c = out.currentSaltVand;
    p = out.powerSaltVand;
    s = out.SOCSaltVand;
    t = out.tout;
elseif (batType == "b")
    v = out.voltageBlySyre;
    c = out.currentBlySyre;
    p = out.powerBlySyre;
    s = out.SOCBlySyre;
    t = out.tout;
elseif (batType == "n")
    v = out.voltageNiMH;
    c = out.currentNiMH;
    p = out.powerNiMH;
    s = out.SOCNiMH;
    t = out.tout;   
elseif (batType == "lis")
    v = out.voltageLiIonLille;
    c = out.currentLiIonLille;
    p = out.powerLiIonLille;
    s = out.SOCLiIonLille;
    t = out.tout;   
elseif (batType == "lil")
    v = out.voltageLiIonStor;
    c = out.currentLiIonStor;
    p = out.powerLiIonStor;
    s = out.SOCLiIonStor;
    t = out.tout;   
end


%Vi laver data så det kan sendes ind i CSV fil som noget C koe kan læse
t = ["time"; double(t)];
v = ["voltage"; double(v)];
c = ["current"; double(c)];
s = ["soc"; double(s)];
p = ["power"; double(p)];

t = double(t);
v = double(v);
c = double(c);
s = double(s);
p = double(p);

%Skriver værdierne ud i en matrix
writematrix(data, '/Users/jenslawl/Documents/Centos/test_results.csv');

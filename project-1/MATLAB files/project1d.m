% Project 1d
% Calculate the coordinates of the wires of a flat discone antenna
%
% Foteini Savvidou (AEM: 9657)

clc;
clear;

lambda = 1.5;
r = 0.25*lambda;
l = 0.3*lambda;
theta = pi/6;
d = lambda/20;
wire_r = lambda/300;
generate_flat_discone_antenna(r,l,theta,d,wire_r);

function generate_flat_discone_antenna(r,l,theta,d,wire_r)
    % GENERATE_FLAT_DISCONE_ANTENNA Local function that calculates the
    % coordinates of the wires of a flat discone antenna and generates a 
    % 4nec2 compatible file
    % Inputs:
    %   r: radius of the disk
    %   l: length of cone wires
    %   theta: angle between cone and z axis
    %   d: distance between disk and cone
    %   wire_r: radius of the wires

    % Number of segments
    nSegments = 7;
    
    % Calculate the coordinates of the ground (flat disk)
    disk = zeros(2,6);
    disk(1,4) = r;      % the x coordinate of the end of the 1st wire
    disk(2,4) = -r;     % the x coordinate of the end of the 2nd wire
    
    % Calculate the coordinates of the flat cone (circular sector)
    cone_start = zeros(8,3);
    cone_end = zeros(8,3);
    cone_start(:,3) = -d;
    phi = theta;
    for i = 1:4
        cone_end(i,1) = -l*sin(phi);
        cone_end(9-i,1) = -cone_end(i,1);
        cone_end([i, 9-i],3) = -d-l*cos(phi);
        phi = phi - 2*theta/7;
    end

    % Discone antenna data (disk, cone, source wire)
    data = [(1:2)', nSegments*ones(2,1), disk, wire_r*ones(2,1);
            (3:10)', nSegments*ones(8,1), cone_start, ...
            cone_end, wire_r*ones(8,1);
            11, 1, 0, 0, 0, 0, 0, -d, wire_r];

    % Generate nec file
    fileID = fopen('flat_discone.nec','w');
    fprintf(fileID,'%s\n',"CE");
    format_spec = 'GW %d %d %.4f %.4f %.4f %.4f %.4f %.4f %.4f\n';
    fprintf(fileID,format_spec,data');
    fprintf(fileID,'%s\n',"GE 0");
    fprintf(fileID,'%s\n',"EN");
    fclose(fileID);
end

% Project 1a
% Calculate the coordinates of the wires of a discone antenna
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
generate_discone_antenna(r,l,theta,d,wire_r);

function generate_discone_antenna(r,l,theta,d,wire_r)
    % GENERATE_DISCONE_ANTENNA Local function that calculates the
    % coordinates of the wires of a discone antenna and generates a 4nec2
    % compatible file
    % Inputs:
    %   r: radius of the disk
    %   l: length of cone wires
    %   theta: angle between cone and z axis
    %   d: distance between disk and cone
    %   wire_r: radius of the wires

    % Number of segments
    nSegments = 9;
    
    % Calculate the coordinates of the disk
    disk_start = zeros(8,3);
    disk_end = zeros(8,3);
    phi = 0;
    for i = 1:8
        disk_end(i,1) = r*cos(phi);
        disk_end(i,2) = r*sin(phi);
        phi = phi + pi/4;
    end
    
    % Calculate the coordinates of the cone
    cone_start = zeros(8,3);
    cone_end = zeros(8,3);
    cone_start(:,3) = -d;
    cone_end(:,3) = -d-l*cos(theta);
    phi = 0;
    for i = 1:8
        cone_end(i,1) = l*sin(theta)*cos(phi);
        cone_end(i,2) = l*sin(theta)*sin(phi);
        phi = phi + pi/4;
    end

    % Discone antenna data (disk, cone, source wire)
    data = [(1:8)', nSegments*ones(8,1), disk_start, ...
            disk_end, wire_r*ones(8,1);
            (9:16)', nSegments*ones(8,1), cone_start, ...
            cone_end, wire_r*ones(8,1);
            17, 1, 0, 0, 0, 0, 0, -d, wire_r];

    % Generate nec file
    fileID = fopen('discone.nec','w');
    fprintf(fileID,'%s\n',"CE");
    format_spec = 'GW %d %d %.4f %.4f %.4f %.4f %.4f %.4f %.4f\n';
    fprintf(fileID,format_spec,data');
    fprintf(fileID,'%s\n',"GE 0");
    fprintf(fileID,'%s\n',"EN");
    fclose(fileID);
end

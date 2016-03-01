function print_array(array, name, fname)
% print_array(array, name)
%
% Read the laboratory manual for further instructions
%

    

N=max(size(array));

if nargin==1
    name='A';
    fname='array.txt';
end
if nargin==2
    fname='array.txt';
end


% writing the .c file
filename=fname; %'array.txt';
fid=fopen(filename, 'w');

%fprintf(fid, '#include "data.h"\n\n');
ss=sprintf('\t// array %s\n', name);
fprintf(fid, '\t// array %s\n', name);
fprintf(fid, 'float %s[] = { ', name ) ;
ss=[ss sprintf('float %s[] = { ', name )] ;

%ss=[ss sprintf()];
for i=1:(N-1),
    fprintf(fid,'%f, ', array(i))    ;
    ss=[ss sprintf('%f, ', array(i))];
    if (mod(i,5)==0) 
        fprintf(fid,'\n\t\t'); 
        ss=[ss sprintf('\n\t\t')];
    end
end
fprintf(fid,'%f ', array(N));
ss=[ss sprintf('%f ', array(N))];


fprintf(fid, '};\n\n'); 
ss=[ss sprintf('};\n\n')];

ss
fclose(fid);


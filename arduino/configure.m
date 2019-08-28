%%%% Configure some settings %%%%

% If Neuroblinks is launched from the root directory of the mouse, make a new directory for the session, otherwise leave that up to the user
cwd=regexp(pwd,'\\','split');
if regexp(cwd{end},'[A-Z]\d\d\d')  % Will match anything of the form LDDD, where L is single uppercase letter and DDD is a seq of 3 digits
    mkdir(datestr(now,'yymmdd'))
    cd(datestr(now,'yymmdd'))
end

% ------ Letter for mouse -----
path1=pwd;
ind1=find(path1=='\');
try
metadata.mouse=path1(ind1(end-1)+1:ind1(end)-1);
catch
    error('Must be in a mouse folder')
end

% ------ Initial value of the conditioning table ----

% Search for per-mouse config file and load it if it exists, otherwise default to the paramtable below

mousedir=regexp(pwd,['[A-Za-z]:\\.*\\', metadata.mouse],'once','match');
condfile=fullfile(mousedir,'condparams.csv');

if exist(condfile)
	paramtable.data=csvread(condfile);
else
	paramtable.data=...
  [4,  230, 7, 200, 25, 3, 0, 0, 0, 230, 1, 0, 200, 800, 15, 5, 0, 255, 1, 10; ...
   1,  230, 7, 200, 0, 3, 0, 0, 0, 230, 1, 0, 200, 800, 15, 5, 0, 255, 1, 100; ...
     ];
end

paramtable.randomize=1;

trialtable=makeTrialTable(paramtable.data,paramtable.randomize);

setappdata(0,'paramtable',paramtable);
setappdata(0,'trialtable',trialtable);
setappdata(0,'metadata',metadata);
pause(0.3);

function CreateQuiz(NumStudents,quiznumber,precision,totalpages,shuffle)
%function CreateQuiz(NumStudents,quiznumber,precision,totalpages,shuffle)
%if shuffle is set to 1 the pages will be shuffled.
tic

%%%Create Quiznames
quiznames = {};
for idx = 1:NumStudents
  quiznames=[quiznames;['Copy',num2str(idx)]];
end
%pause
%%%%Run Parse Tex
name_of_file = ['Q',num2str(quiznumber),'-%s.tex']
parsetex(name_of_file,quiznames,precision);

%%%Convert Tex Files to PDF
files = dir;
for ii = 1:length(files)
  files(ii).name
  [directory,name,extension] = fileparts(files(ii).name);
  if strcmp(extension,'.tex')
    system(['pdflatex ',[name,'.tex']]);
    system(['pdflatex ',[name,'.tex']]);
  end
end

%%%Remove Master File
masterfilepdf = ['Q',num2str(quiznumber),'-gradingkey.pdf'];
system(['rm ',masterfilepdf]);

%%%Protect Master file
masterfiletex = ['Q',num2str(quiznumber),'-gradingkey.tex'];
system(['mv ',masterfiletex,' ',masterfiletex,'.backup']);

%%%Clean Up
system('rm *.aux *.log *.tex');

%%%Restore master file
system(['mv ',masterfiletex,'.backup ',masterfiletex]);

%%%Run pdftk to combine everything into a single printed version
system('rm MasterQuiz.pdf');
files = dir;
system('echo "" | ps2pdf -sPAPERSIZE=a4 - pageblank.pdf');
ctr = 1;
for ii = 1:length(files)
  %files(ii).name
  [directory,name,extension] = fileparts(files(ii).name);
  if strcmp(extension,'.pdf')
    if ctr == 1
      system(['mv Q',num2str(quiznumber),'-Copy1.pdf MasterQuiz.pdf']);
      if mod(totalpages+1,2) %%Take solutions page into account
	system(['pdftk MasterQuiz.pdf pageblank.pdf cat output output.pdf']);
	system(['mv output.pdf MasterQuiz.pdf']);
      end
      ctr = ctr + 1;
    else
      system(['pdftk ',[name,'.pdf'],' burst']);
      
      %%%The last page is solutions so put those in a separate folder
      %%%Get Root
      if (totalpages+1)>9
	pg = 'pg_00';
      else
	pg = 'pg_000';
      end
      system(['cp ',pg,num2str(totalpages+1),'.pdf Solutions/Copy-',name,'.pdf']);
      command = ['pdftk MasterQuiz.pdf pg_0001.pdf '];
      o = 2:totalpages;
      if shuffle == 1
	[y,I] = sort(rand(1,length(o)));
	newo = o(I);
      else
	newo = o;
      end
      for idx = 1:length(newo)
	if newo(idx) > 9
	  pg = 'pg_00';
	else
	  pg = 'pg_000';
	end
	command = [command,pg,num2str(newo(idx)),'.pdf '];
      end
      if mod(totalpages,2)
	command = [command,'pageblank.pdf' ];
      end
      command = [command,' cat output output.pdf'];
      system(command);
      system(['mv output.pdf MasterQuiz.pdf']);
      
    end
  end
end
%%Clean up again
system(['rm pg*.pdf *Copy*.pdf pageblank.pdf']);

function parsetex(filename,quiznames,precision)
% parsetex - Parse specialized LaTeX file with embedded MATLAB commands
%            to create unique homework sets, tests, exams, etc.
%
% Usage: parsetex(filename,quiznames)
%
% where: filename - template name for original LaTeX file, e.g.:
%                   'me2000-01-%s.tex'
%        quiznames - cell vector of quiz names - can be student
%        names or just dummy numbers
%
% parsetex reads a grading key file which is mostly LaTeX code, but also
% has MATLAB commands embedded inside '**' tags. It passes the embedded
% MATLAB commands into eval(), and assuming that there are no '='
% characters in the command, replaces the tagged command with its result.
%
% parsetex will create a new .tex file for each quiz listed in
% quiznames. To the extent that the MATLAB commands involve random
% numbers, each student's file will have a different set of parameters on
% each question.

% FOR REPEATABILITY ..added by JDR..

%a = toc;
%rand('seed',a)
disp('Running Parse Tex')

for m=1:length(quiznames)
    quizName=char(quiznames(m));
    templatefile=sprintf(filename,'gradingkey')
    studentfile=sprintf(filename,quizName);
    fid = fopen(templatefile, 'r');
    fprintf('Creating file %s: ',studentfile);
    fidout = fopen(studentfile, 'w');
    while (~feof(fid))
        line = fgetl(fid);
        tagCount=max([length(findstr(line,'**')) length(findstr(line,'^^'))])/2;
        if tagCount>=1
            for n=1:tagCount
                starPositions=findstr(line,'**');
                caretPositions=findstr(line,'^^');
                if length(starPositions)>=1
                    starBeginPosition=starPositions(1);
                    starEndPosition=starPositions(2);
                    res = line((starBeginPosition+2):(starEndPosition-1));
                    result=eval(res);
                    if ~isa(result,'char')
                        result=num2str(result,['% 15.',num2str(precision),'f']);
                    end;
                    line=strrep(line,line(starBeginPosition:(starEndPosition+1)),result);
                end
                if length(caretPositions)>=1
                    caretBeginPosition=caretPositions(1);
                    caretEndPosition=caretPositions(2);
                    res = line((caretBeginPosition+2):(caretEndPosition-1));
                    try
                        eval(res);
                    catch me
                        disp(['This command is incorrect: ',res])
                        disp(['With error: ',me.message])
                        error('Stopped')
                    end
                end
            end
        end
        fprintf(fidout, '%s\n', char(line));
    end
    fclose(fid);
    fclose(fidout);
    fprintf('done\n');
end

% Copyright - Carlos Montalvo 2015
% You may freely distribute this file but please keep my name in here
% as the original owner

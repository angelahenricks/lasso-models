% go to where output data files exist
cd('C:\Users\angela.henricks\OneDrive - Washington State University (email.wsu.edu)\Desktop\Research\MatlabAnalysis\Sexdiffdata')
% pre-allocate arrays
[thisFAUC,thisFAUCR] = deal(zeros(1,100));
[x,y,xR,yR] = deal(cell(1,100));
% cycle through all 100 files, load them, apply model to test set to get
% AUC
for ii = 1:100
   % Load iith file
    load(['SexDiffData',num2str(ii),'.mat'])
   % Apply mdl to test set
   pred = cvglmnetPredict(acc{1}.mdl{1},hist.cfg.naive.testX);
   % Compare prediction to actual Y; generates AUC; uses thisAUC to not
   % overwrite auc variable
   [x{ii},y{ii},~,thisAUC(ii)] = perfcurve(hist.cfg.naive.testY,...
       pred,1);
   % Do the same as above with randomized data
   predR = cvglmnetPredict(accR{1}.mdl{1},histR.cfg.naive.testX);
   [xR{ii},yR{ii},~,thisAUCR(ii)] = perfcurve(histR.cfg.naive.testY,...
       predR,1);
end
%%
pd = fitdist(thisAUC','normal');
pdR = fitdist(thisAUCR','normal');
x = 0:0.01:1;
y = pdf(pd,x);
yR = pdf(pdR,x);
figure
hold on
plot(x,y)
plot(x,yR)
legend({['Real: \mu = ',num2str(round(mean(thisAUC),2)),'\pm',...
    num2str(round(conf(thisAUC,0.95),2))],...
    ['Permuted: \mu = ',num2str(round(mean(thisAUCR),2)),'\pm',...
    num2str(round(conf(thisAUCR,0.95),2))]})
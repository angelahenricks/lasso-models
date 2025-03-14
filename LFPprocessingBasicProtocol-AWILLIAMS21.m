%% LFP data processing_basic protocol for lasso
%Step 0: Split files so each animal/rec has its own file
    You can use fileSplitter or manually split files with PlexUtil
    files must be in PLX to split but in PL2 to convert to matlab files
%Step 1: convert files to matlab
    You can use ConvertPl2All_Files function
%Step 2: Preprocessing using fileCycle
    2.1: in scbParamsMulti fucntion change parameters for your study.
        this creates the cfg internally; the variables you need to analyze the data
    2.2: fileCycle runs spectcombbase function on all files instead of individually
        change save directory in this function
%Step 3: collateData function organizes data
    collates data from many files into matrices
    make sure you know the order of your files. You can use [data,~,files] = collateData to create a variable with file names. The order of the files should match Y data when doing a continuous prediction.
%Step 4: concatonate the data using 'cat' command
    organizes the data into your groups (eg. males and females)
%Step 5: lassoNetcfg function
%Step 6: lassoNet function
    create your Y variables before running this function
%Step 7: make histogram
    doubleHist function; need to make matrices with all errors for each lassonet you run (e.g., one for real and one for permuted)
    example: allerror = [allLambda{1,1}.allErr];
%Step 8: identify individual features (optional)
    example for jj = 1:126
        mdl = fitglm(maleNoCA(:,jj),maleY);
        maleDev(jj) = mdl.Deviance;
        maleR(jj) = mdl.Rsquared.Ordinary;
        end
    nameVect = names({'ILL','PLL','NAcL','PLR','ILR','NAcR'},{'d','t','a','b','lg','hg'});
    [maleRS,sortInd] = sort(maleR,'descend');
    sortName = nameVect(sortInd);
%%
function [Labels, DecisionValue]= CLSosusvmC(Samples, Model);
%function [Labels, DecisionValue]= CLSosusvmC(Samples, Model);
%
%wrapper function for osu svm classification
%Samples contains the data-points to be classified as COLUMNS, i.e., it is nfeatures \times nexamples
%Model is the model returned by CLSosusvm
%Labels are the predicted labels
%DecisionValue are the values assigned by the Model to the points (Labels = sign(DecisionValue))

[Labels, DecisionValue]= SVMClass(Samples, Model.AlphaY, ...
                                  Model.SVs, Model.Bias, ...
				  Model.Parameters, Model.nSV, Model.nLabel);
Labels = Labels';
DecisionValue = DecisionValue';

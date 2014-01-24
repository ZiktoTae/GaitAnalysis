pos_data = csvread('walk.csv');
neg_file = {'david_walk_trial_1.csv' 'shawn_trial_1.csv' 'shawn_trial_2.csv'};
neg_data=[];
pos_data = extractFeature('walk.csv');
for i = 1:length(neg_file)
    neg_data = [neg_data extractFeature(neg_file{i})];
end

dataset = [pos_data' ; neg_data'];
group = [ ones(1,length(pos_data)) zeros(1,length(neg_data))];

trained_data = svmtrain(dataset,group,'showplot','true');

score=zeros(1,length(dataset));
for i = 1:length(dataset)
    score(i)=svmclassify(trained_data, dataset(i,:));
end

plot(score,'r+')

pos = sum(score(1:length(pos_data)))/length(pos_data) * 100
neg = sum(score(length(pos_data)+1:length(pos_data)+length(neg_data)))/length(neg_data) * 100
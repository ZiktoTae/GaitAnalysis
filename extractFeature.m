function feature = extractFeature(filename)

data = csvread(filename);

Fs = 200; %Sampling Frequency
n = 5; %Order
Wn = 5; %Cut off Frequency
Fn = Fs/2; %Nyquist Frequency

[b,a] = butter(n, Wn/Fn, 'low');
low_passed_data = filter(b,a,data);

extrema = extr(low_passed_data);
pos_extrema = low_passed_data .* extrema{1}';
neg_extrema = low_passed_data .* extrema{2}';

prev_pos_extrema = inf;
second_peak = false;


extrema_counter=1;
segmentation_mask = zeros(1,3);
list = zeros(1,100);
for i = 1:length(extrema{1})
   if(extrema{1}(i))
       list(extrema_counter) = i;
       extrema_counter=extrema_counter+1;
   end
end

list=list(list~=0);  % remove all zeros

segmentation = zeros(1,100);
index = 1 ;
for i = 3:length(list)
   if( low_passed_data(list(i-2)) > low_passed_data(list(i-1)))
       segmentation(index)=list(i);
       index=index+1;
   end
end
segmentation = segmentation(segmentation~=0);

start_array = zeros(1,length(segmentation));
end_array = zeros(1,length(segmentation));
index=1;
%create feature data
for i = 2 : length(segmentation)
    start_index = segmentation(i-1);
    end_index = segmentation(i);
    extrema_count = sum(extrema{1}(start_index:end_index))+sum(extrema{2}(start_index:end_index));
    if(extrema_count ==5)
        start_array(index)=start_index;
        end_array(index)=end_index;
        index=index+1;
    end
end

start_array = start_array(start_array~=0);
end_array = end_array(end_array~=0);

base_points = zeros(5,length(start_array));
feature_lines = zeros( 3, length(start_array));

for i = 1:length(start_array)
    %1st point
    %base_points(1,i) = start_array(i);
    base_points(5,i) = end_array(i);
    base_index=1;
    for j = start_array(i):end_array(i)
        if(extrema{1}(j) || extrema{2}(j))
            base_points(base_index,i)=j;
            base_index=base_index+1;
        end
    end
end

for n = 1:length(base_points)
    index=1;
    width = base_points(5,n)-base_points(1,n);
    for i = 2:4
      feature_lines(index,n) = (base_points(i,n)-base_points(1,n))/width;
      index=index+1;
    end
end

feature = feature_lines;
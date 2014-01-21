

data_file = load('walk.mat');
data = data_file.walk;

%data = walk_room_normal;

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
    extrema_count = sum(extrema{1}(start_index:end_index))+sum(extrema{2}(start_index:end_index))
    if(extrema_count ==5)
        start_array(index)=start_index;
        end_array(index)=end_index;
        index=index+1;
    end
end

start_array = start_array(start_array~=0);
end_array = end_array(end_array~=0);

base_points = zeros(5,length(start_array));
features = zeros( 10, length(start_array));

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

subplot(2,1,1);
plot(data)

subplot(2,1,2);
plot(low_passed_data);hold on;
plot(pos_extrema,'r+');
plot(neg_extrema,'rx');

for i = 1:length(segmentation)
   line([segmentation(i) segmentation(i)],[0 20],'Color',[1 0 0]);
end


hold off;
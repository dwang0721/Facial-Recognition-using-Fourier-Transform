clear;
clc;
close all;

folder_path = 'att_faces/s*';
image_path = 'att_faces/s*/*.pgm';
files = ["test_17_4.pgm", "test_32_9.pgm", "test_7_7.pgm"];
test_file = char(files(3));

%% read from database
image_data = read_images(image_path);
% pad each image to 128x128, each image is padded stored in a cell array
pad_image_data = cellfun(@(x) padarray(x,[8,18],'replicate'),image_data,'UniformOutput',false);
% get absolute, real, and imaginary frequency, in cell format,
% get_frequency(x,1,1), 1: normalize frequency, 1:shift the zero frequency to the center
[img_f_abs, img_f_real, img_f_imag] = cellfun(@(x)get_frequency(x,1,1),pad_image_data,'UniformOutput',false);

% view the variance map, 1 is to normalize the display
abs_var_map = get_variance_map(img_f_abs,1); 
real_var_map = get_variance_map(img_f_real,1);
imag_var_map = get_variance_map(img_f_imag,1);
display_freq(abs_var_map, 'Variance');
display_freq(real_var_map, 'Variance real part');
display_freq(imag_var_map, 'Variance imaginary part');


%% locate the most variant frequency and set those to zeros
% display the sample image
sample = double(imread(test_file))/255;

% sample = flip(sample, 1);

sample = padarray(sample,[8,18],'replicate');
% sample = imrotate(sample,5,'crop');

display_freq(sample, 'Sample');

% display fft of the sample image
sample_fft = fft2(sample); 
display_freq(sample_fft, 'sample fft');

%get the overall frequency in DATABASE. normalize but not shift.
[~, img_f_real, img_f_imag] = cellfun(@(x)get_frequency(x,1,0),pad_image_data,'UniformOutput',false);
real_var_map = get_variance_map(img_f_real,1); % input 1: normalize the display
imag_var_map = get_variance_map(img_f_imag,1);

% locate the big variance in both parts of the image data
big_variance_real = real_var_map > 0.7;
big_variance_imag = imag_var_map > 0.05;


%% test 1: set the most variant frequency to zero, and compare
% set these frequence to zero in the sample image
sample_real = real(sample_fft);
sample_imag = imag(sample_fft);
sample_real (big_variance_real) = 0;
sample_imag (big_variance_imag) = 0;
% set the frequency to zero
sample_fft_delete_frequency = complex(sample_real, sample_imag);
% invert fft using ifft
recover_fft = ifft2(sample_fft_delete_frequency);
display_freq(recover_fft, 'recover');


%% extract the most variant frequency from sample fft
% take the real and imaginary part again from sample fft
sample_real_key = real(sample_fft);
sample_imag_key = imag(sample_fft);
% mask out the most vairant frequency.
sample_real_key (big_variance_real == 0) = 0;
sample_imag_key (big_variance_imag == 0) = 0;


%% extract the most variant frequency from the database

path = dir(folder_path);
num_folder = length(path);
% store the feature frequency for each person, devided into real and imag
frequency_real = [];
frequency_imag = [];

% go thru each folder, store the avg real and imaginary frequency
for i = 1:num_folder
    %load images in each image_path
    image_path = strcat(path(i).folder, '\s', string(i),'\*.pgm');
    data = read_images(image_path);
    %padd images in each folder, the size should be 1x10 cell array
    pad_image_data = cellfun(@(x) padarray(x,[8,18],'replicate'),data,'UniformOutput',false);
    
    % fft of Pad_image_data, real and imag are both 1x10 cell array
    [~, img_f_real, img_f_imag] = cellfun(@(x)get_frequency(x,0,0),pad_image_data,'UniformOutput',false);
    
    % average 10 frequencies in real part
    img_f_real =  cat(3, img_f_real{:});
    img_f_real_avg = mean(img_f_real,3);
    
    % average 10 frequencies in imaginary part
    img_f_imag =  cat(3, img_f_imag{:});
    img_f_imag_avg = mean(img_f_imag,3);
    
    % take only the most variant part
    img_f_real_avg (big_variance_real == 0) = 0;
    img_f_imag_avg (big_variance_imag == 0) = 0;
    
    frequency_real = cat(3, frequency_real,img_f_real_avg);
    frequency_imag = cat(3, frequency_imag,img_f_imag_avg);
end


%% calculate the feature distance between sample and image data
feature_dis_real = [];
feature_dis_imag = [];

for i = 1:num_folder
   real_distance =  feature_distance(sample_real_key, frequency_real(:,:,i));
   imag_distance =  feature_distance(sample_imag_key, frequency_imag(:,:,i));
   feature_dis_real = [feature_dis_real, real_distance];
   feature_dis_imag = [feature_dis_imag, imag_distance];
end

% find the minimun distance and its index, 
[min_dis_real,min_index_real] = min(feature_dis_real)
[min_dis_imag,min_index_imag] = min(feature_dis_imag)



function x = feature_distance(A, B)
%The distances between the feature vectors
    M = abs(A-B);
    x = sum(sum(M));
end

function [f_abs, f_real, f_imag] = get_frequency (image, normalize, shift)
    
    f=fft2(image);  %Take 2D Fast Fourier.
    
    % Compute magnitude of complex numbers using abs.
    f_abs = abs(f);    
    if normalize
        f_abs = normalize_abs_freq(f_abs, shift);   
    end
    
    % real part
    f_real = real(f); 
    if normalize
        f_real = normalize_freq(f_real, shift);     
    end
    
    % imaginary part
    f_imag = imag(f);
    if normalize
        f_imag = normalize_freq(f_imag, shift); 
    end
end

function data = read_images(image_path)
% function to read all pgms and store them in an cell array
path = dir(image_path);
num_files = length(path);
data = cell(1,num_files);

    for i = 1:num_files
        file_name = strcat(path(i).folder, '\', path(i).name);
        image= double(imread(file_name))/255;
        data{i} =image;
    end
end 

function y = normalize_abs_freq(f_abs, shift)   
    f_abs=log(f_abs); %Take log just for display purposes since range will be large.
    f_abs=f_abs-min(f_abs(:));
    if shift
        f_abs = fftshift(f_abs);
    end
    y = f_abs/max(f_abs(:)); %Scale to 0-1.
end

function y = normalize_freq(freq, shift)
    % shift to shift 0 freq to the center.
    freq = freq-min(freq(:)); 
    freq = freq/max(freq(:));
    if shift
        freq = fftshift(freq);
    end
    
    y = freq;
end

function display_freq(freq, text)
    figure;
    imshow(freq);    
    title(strcat("Display ", text));    
end

function var_map=get_variance_map(freq_data,normalize) 
    % taking frequency data in cell format
    image_array = cat(3, freq_data{:}); % convert image data into a 3d matix.
    var_map = var(image_array,0,3); % calculate the variance of each pixel
    if normalize
        var_map = normalize_freq(var_map, 0);
    end
    
end

%% MATLAB Implementation of "A secure image encryption algorithm based on Rubik's cube principle."
% Code: Shujaat Khan shujaat123@gmail.com

% Citation: 
% Loukhaoukha, Khaled, Jean-Yves Chouinard, and Abdellah Berdai.
% "A secure image encryption algorithm based on Rubik's cube principle."
% Journal of Electrical and Computer Engineering 2012 (2012).

clc
clear all
close all
%%
Io = imread('cameraman.tif');
% Io=imresize(Io,[16 15]);

%% Initialize
nbits = 8;
[M, N] = size(Io);

%% Step1
Kr = randi([0,(2^nbits)-1],[1,M]);
Kc = randi([0,(2^nbits)-1],[1,N]);

%% Step2
ITERmax = 10;

figure(1), subplot(1,3,1), imshow(Io)

%% Encryption
I_ENC = Io;
for i=1:ITERmax %% Step3
    %% Step4
    alpha_i = sum(I_ENC,2);
    M_alpha_i = 1-2*mod(alpha_i,2);
    
    for m=1:M
        I_SCR(m,:) = circshift(I_ENC(m,:),M_alpha_i(m));
    end
    
    %% Step5
    beta_i = sum(I_SCR,1);
    M_beta_i = 1-2*mod(beta_i,2);

    for n=1:N
        I_SCR(:,n) = circshift(I_SCR(:,n),M_beta_i(n));
    end
    
    %% Step6
    for j=1:N
        I1(1:2:M,j) = bitxor(I_SCR(1:2:M,j),Kc(j),'uint8');
        I1(2:2:M,j) = bitxor(I_SCR(2:2:M,j),Kc(end-j+1),'uint8');
    end
    %% Step7
    for i=1:M
        I_ENC(i,1:2:N) = bitxor(I1(i,1:2:N),Kr(i),'uint8');
        I_ENC(i,2:2:N) = bitxor(I1(i,2:2:N),Kr(end-i+1),'uint8');
    end
end %% Step8

figure(1), subplot(1,3,2), imshow(I_ENC)

%% Decryption
I_DEC = I_ENC;
for i=1:ITERmax %% Step1~2
    %% Step3
    for i=1:M
        I1(i,1:2:N) = bitxor(I_DEC(i,1:2:N),Kr(i),'uint8');
        I1(i,2:2:N) = bitxor(I_DEC(i,2:2:N),Kr(end-i+1),'uint8');
    end
    
    %% Step4
    for j=1:N
        I_SCR(1:2:M,j) = bitxor(I1(1:2:M,j),Kc(j),'uint8');
        I_SCR(2:2:M,j) = bitxor(I1(2:2:M,j),Kc(end-j+1),'uint8');
    end
    
    %% Step5
    beta_i = sum(I_SCR,1);
%     M_beta_i = 1-2*mod(beta_i,2);
    M_beta_i = 2*mod(beta_i,2)-1;

    for n=1:N
        I_DEC(:,n) = circshift(I_SCR(:,n),M_beta_i(n));
    end
    
    %% Step6
    alpha_i = sum(I_DEC,2);
%     M_alpha_i = 1-2*mod(alpha_i,2);
    M_alpha_i = 2*mod(alpha_i,2)-1;
    
    for m=1:M
        I_DEC(m,:) = circshift(I_DEC(m,:),M_alpha_i(m));
    end  
end %% Step7

figure(1), subplot(1,3,3), imshow(I_DEC)

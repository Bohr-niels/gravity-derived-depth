oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin')

clc
clear

free=load('free.txt');
control=load('control.txt');
check=load('check.txt');
range='142.6/147.3/23/27';
%free.txtΪ�����쳣����
%control.txtΪˮ����Ƶ�
%check.txtΪˮ���˵�

result=GGM(free,control,check,-8000,range)

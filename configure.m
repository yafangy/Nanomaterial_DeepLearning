function [] = configure(varargin)
%CONFIGURE Configure the paths for the package
%  [] = configure() add the current and children directories to the paths
%  [] = configure(path) add the specified path and children directories to
%  the paths

if nargin == 0
    pathname = pwd;
elseif nargin == 1
    pathname = varargin{1};
else
    error('input arguments does not match');
end

addpath(genpath(pathname));


end


function mask = QGetObjectMask(objects,dims)
%function mask = QGetObjectMask(objects,dims)

n_objects = size(objects,2);
mask = zeros(dims(1:2));
for i =1:n_objects
    tmask = roipoly(dims(1),dims(2),objects{i}(:,1), objects{i}(:,2));
    mask = mask | tmask;
end


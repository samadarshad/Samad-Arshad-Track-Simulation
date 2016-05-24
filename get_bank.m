%function to get bank angle


function bank_angle = get_bank(point,VectsStruct)

%VectsStruct = get_vects(MeshSt,point);
flat_vec = [VectsStruct.sl(:,1:2) zeros(1,1)]; %relative to z=0
bank_angle = atan2(norm(cross(VectsStruct.sl',flat_vec')),dot(VectsStruct.sl',flat_vec'));
bank_angle = 180/pi * bank_angle;




end

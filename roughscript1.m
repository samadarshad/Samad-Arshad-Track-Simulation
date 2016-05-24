%inspect quality of lane aero mapping



mesh(MeshSt.x_mat,MeshSt.y_mat,zeros(size(MeshSt.x_mat)))
axis equal
hold on
scatter(lanes(1).aero_mapping.x(:),lanes(1).aero_mapping.y(:))
scatter(testlane.x(:),testlane.y(:))
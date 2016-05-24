%function to get radius of curvature at cyclists centre of grav

%eqn 50

function Rc = get_Rc(Rw,h_cg,m_wheel,m_bikeframe_cyclist,D,lean_angle)



y = h_cg - D/2;

x = m_wheel*y/m_bikeframe_cyclist;

Rc = Rw - (h_cg + x)*sind(lean_angle);

end
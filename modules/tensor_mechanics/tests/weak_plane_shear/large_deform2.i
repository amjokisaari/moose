# large strain with weak-plane normal rotating with mesh
# First rotate mesh 45deg about x axis
# Then apply stretch in the y=z direction.
# This should create a pure tensile load (no shear), which
# should return to the yield surface.
#
# Since cohesion=1E6 and tan(friction_angle)=1, and
# wps_smoother = 0.5E6, the apex of the weak-plane cone is
# at normal_stress = 0.5E6.  So, the result should be
# s_yy = s_yz = s_zz = 0.25E6
[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = -0.5
  zmax = 0.5
[]


[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  [../]
[]


[BCs]
  # rotate:
  # ynew = c*y + s*z.  znew = -s*y + c*z
  [./bottomx]
    type = FunctionPresetBC
    variable = disp_x
    boundary = back
    function = '0'
  [../]
  [./bottomy]
    type = FunctionPresetBC
    variable = disp_y
    boundary = back
    function = '0.70710678*y+0.70710678*z-y'
  [../]
  [./bottomz]
    type = FunctionPresetBC
    variable = disp_z
    boundary = back
    function = '-0.70710678*y+0.70710678*z-z'
  [../]

  [./topx]
    type = FunctionPresetBC
    variable = disp_x
    boundary = front
    function = '0'
  [../]
  [./topy]
    type = FunctionPresetBC
    variable = disp_y
    boundary = front
    function = '0.70710678*y+0.70710678*z-y+if(t>0,1,0)'
  [../]
  [./topz]
    type = FunctionPresetBC
    variable = disp_z
    boundary = front
    function = '-0.70710678*y+0.70710678*z-z+if(t>0,1,0)'
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield_fcn]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./yield_fcn_auxk]
    type = MaterialStdVectorAux
    property = plastic_yield_function
    index = 0
    variable = yield_fcn
  [../]
[]

[Postprocessors]
  [./s_xx]
    type = PointValue
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./s_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./s_yz]
    type = PointValue
    point = '0 0 0'
    variable = stress_yz
  [../]
  [./s_zz]
    type = PointValue
    point = '0 0 0'
    variable = stress_zz
  [../]
  [./f]
    type = PointValue
    point = '0 0 0'
    variable = yield_fcn
  [../]
[]

[UserObjects]
  [./coh]
    type = TensorMechanicsHardeningConstant
    value = 1E6
  [../]
  [./tanphi]
    type = TensorMechanicsHardeningConstant
    value = 1
  [../]
  [./tanpsi]
    type = TensorMechanicsHardeningConstant
    value = 0.111107723
  [../]
  [./wps]
    type = TensorMechanicsPlasticWeakPlaneShear
    cohesion = coh
    tan_friction_angle = tanphi
    tan_dilation_angle = tanpsi
    smoother = 0.5E6
    yield_function_tolerance = 1E-9
    internal_constraint_tolerance = 1E-9
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    block = 0
    fill_method = symmetric_isotropic
    C_ijkl = '0 1E7'
  [../]
  [./strain]
    type = ComputeFiniteStrain
    block = 0
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./mc]
    type = ComputeMultiPlasticityStress
    block = 0
    plastic_models = wps
    transverse_direction = '0 0 1'
    ep_plastic_tolerance = 1E-8
    debug_fspb = 1
  [../]
[]


[Executioner]
  start_time = -1
  end_time = 1
  dt = 1
  type = Transient
[]


[Outputs]
  file_base = large_deform2
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  [./csv]
    type = CSV
    interval = 1
  [../]
[]

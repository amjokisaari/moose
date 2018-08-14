# This is an input file to demonstrate the Grain Tracker reporting a higher maximum grain ID than there
# are grains when using the reserved order parameter.  The field is non-uniform.  Also, why would it do
# that in general?

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmin = 0
  xmax = 60
  ymin = 0
  ymax = 60
[]

[GlobalParams]
  op_num = 8
  var_name_base = gr
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    grain_num = 30
    rand_seed = 100
  [../]
  [./grain_tracker]
    type = GrainTracker
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    halo_level = 3
    reserve_op = 1
    reserve_op_threshold = 0.05

    remap_grains =  true
    polycrystal_ic_uo = voronoi
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
      op_num = 7
    [../]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./halos]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./num_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
 [./PolycrystalKernel]
   op_num = 7
 [../]
 #this is here to give the gr7 variable something to do
 [./ac_int]
    type = SimpleACInterface
    variable = gr7
 [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = "initial timestep_end"
  [../]
  [./unique_grains_calc]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = "initial timestep_end"
  [../]
  [./var_indices_calc]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = "initial timestep_end"
  [../]
  [./num_grains_calc]
    type = GrainTrackerNumGrains
    grain_tracker = grain_tracker
    variable = num_grains
  [../]
[]

[Materials]
  [./GenericGrGr]
    type = GBEvolution
    T = 450
    wGB = 4
    GBmob0 = 2.5e-6
    Q = 0.23
    GBenergy = 0.708
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  solve_type = PJFNK

  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm ilu 1'
  petsc_options = '-ksp_converged_reason -snes_converged_reason'

  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 6
  nl_rel_tol = 1.0e-8

  [./TimeStepper]
    type = ConstantDT
    dt = 1e-1
  [../]

  num_steps = 2
[]

[Outputs]

 file_base = GrainTracker_Reserve

 [./console]
    type = Console
    max_rows = 10
    interval = 1
  [../]
  [./exodus]
    type = Exodus
    interval = 1
  [../]
[]

/****************************************************************/
/*                  DO NOT MODIFY THIS HEADER                   */
/*                           Marmot                             */
/*                                                              */
/*            (c) 2017 Battelle Energy Alliance, LLC            */
/*                     ALL RIGHTS RESERVED                      */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*             Under Contract No. DE-AC07-05ID14517             */
/*             With the U. S. Department of Energy              */
/*                                                              */
/*             See COPYRIGHT for full restrictions              */
/****************************************************************/

#include "GrainTrackerNumGrains.h"

registerMooseObject("PhaseFieldApp", GrainTrackerNumGrains);

template <>
InputParameters
validParams<GrainTrackerNumGrains>()
{
  InputParameters params = validParams<AuxKernel>();

  params.addRequiredParam<UserObjectName>("grain_tracker", "the GrainTracker UserObject to get values from");

  return params;
}

GrainTrackerNumGrains::GrainTrackerNumGrains(const InputParameters & parameters)
    : AuxKernel(parameters),
      _grain_tracker(getUserObject<GrainTracker>("grain_tracker"))

{
}

Real
GrainTrackerNumGrains::computeValue()
{

  //Real num_active_grains = _grain_tracker.getNumberActiveGrains();
  //Real num_total_grains = _grain_tracker.getTotalFeatureCount();

 //get the vector that maps active order parameters to grain ids
 const auto & op_to_grains = _grain_tracker.getVarToFeatureVector(_current_elem->id());

 Real max_grain_id = 0;

 //loop over the active OPs
 for (auto op_index = beginIndex(op_to_grains); op_index < op_to_grains.size(); ++op_index)
 {
   auto grain_id = op_to_grains[op_index];

   if (grain_id < FeatureFloodCount::invalid_id && grain_id >= max_grain_id )
     max_grain_id = grain_id;
 }

 return max_grain_id;
}

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

#ifndef GRAINTRACKERNUMGRAINS_H
#define GRAINTRACKERNUMGRAINS_H

#include "AuxKernel.h"

// Forward Declarations
class GrainTrackerNumGrains;

template <>
InputParameters validParams<GrainTrackerNumGrains>();

class GrainTrackerNumGrains : public AuxKernel
{
public:
  GrainTrackerNumGrains(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

private:
  /// Grain tracker used to get unique grain IDs
  const GrainTracker & _grain_tracker;


};

#endif // GRAINTRACKERNUMGRAINS_H

//----------------------------------*-C++-*----------------------------------------------//
/*!
 * \file   quadrature/Interval_Quadrature.hh
 * \author Kelly Thompson
 * \date   Tue Feb 22 10:21:50 2000
 * \brief  A class representing an interval Gauss-Legendre quadrature set.
 * \note   Copyright 2000-2010 Los Alamos National Security, LLC. All rights
 *         reserved. 
 */
//---------------------------------------------------------------------------------------//
// $Id: Quadrature.hh 6718 2012-08-30 20:03:01Z warsa $
//---------------------------------------------------------------------------------------//

#ifndef __quadrature_Interval_Quadrature_hh__
#define __quadrature_Interval_Quadrature_hh__

#include "Quadrature.hh"

namespace rtt_quadrature
{

//=======================================================================================//
/*!
 * \class Interval_Quadrature
 *
 * \brief A class representing an interval quadrature set.
 *
 * This is an abstraction of all interval (e.g. 1D) angle quadrature sets.
 */
//=======================================================================================//

class Interval_Quadrature : public Quadrature 
{
  public:
    
    // CREATORS

    // ACCESSORS

    virtual unsigned number_of_levels() const;

    virtual Quadrature_Class quadrature_class() const;

    // STATICS

  protected:

    using Quadrature::create_ordinates_;

    //! Virtual hook for create_ordinate_set
    virtual vector<Ordinate> create_ordinates_(unsigned dimension,
                                               Geometry,
                                               double norm,
                                               unsigned mu_axis,
                                               unsigned eta_axis,
                                               bool include_starting_directions,
                                               bool include_extra_directions) const;

    //! Virtual hook for create_ordinate_set
    virtual vector<Ordinate> create_ordinates_(unsigned dimension,
                                               Geometry,
                                               double norm,
                                               bool include_starting_directions,
                                               bool include_extra_directions) const;
    
    //! Virtual hook for create_ordinate_set
    virtual vector<Ordinate> create_level_ordinates_(double norm) const = 0;
};

} // end namespace rtt_quadrature

#endif // __quadrature_Quadrature_hh__

//---------------------------------------------------------------------------------------//
//                       end of quadrature/Quadrature.hh
//---------------------------------------------------------------------------------------//
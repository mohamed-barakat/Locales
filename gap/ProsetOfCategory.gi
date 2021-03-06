# SPDX-License-Identifier: GPL-2.0-or-later
# Locales: Locales, frames, coframes, meet semi-lattices of locally closed subsets, and Boolean algebras of constructible sets
#
# Implementations
#

##
InstallValue( CAP_INTERNAL_METHOD_NAME_LIST_FOR_PREORDERED_SET_OF_CATEGORY,
  [
   "IsWellDefinedForObjects",
   "IsHomSetInhabited",
   "TensorUnit",
   "TensorProductOnObjects",
   "InternalHomOnObjects",
   "InternalHomOnMorphismsWithGivenInternalHoms",
   ] );

##
InstallMethod( AsCellOfProset,
        "for a CAP object",
        [ IsCapCategoryObject ],
        
  function( object )
    local P, o;
    
    P := ProsetOfCategory( CapCategory( object ) );
    
    o := rec( );
    
    ObjectifyObjectForCAPWithAttributes( o, P,
            UnderlyingCell, object );
    
    return o;
    
end );

##
InstallMethod( AsCellOfStableProset,
        "for a CAP object",
        [ IsCapCategoryObject ],
        
  function( object )
    local P, o;
    
    P := StableProsetOfCategory( CapCategory( object ) );
    
    o := rec( );
    
    ObjectifyObjectForCAPWithAttributes( o, P,
            UnderlyingCell, object );
    
    return o;
    
end );

##
InstallMethod( AsCellOfProset,
        "for a CAP morphism",
        [ IsCapCategoryMorphism ],
        
  function( morphism )
    local P, m;
    
    P := ProsetOfCategory( CapCategory( morphism ) );
    
    m := rec( );
    
    ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( m, P,
            Source( morphism ) / P,
            Range( morphism ) / P,
            UnderlyingCell, morphism );
    
    return m;
    
end );

##
InstallMethod( AsCellOfStableProset,
        "for a CAP morphism",
        [ IsCapCategoryMorphism ],
        
  function( morphism )
    local P, m;
    
    P := StableProsetOfCategory( CapCategory( morphism ) );
    
    m := rec( );
    
    ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( m, P,
            Source( morphism ) / P,
            Range( morphism ) / P,
            UnderlyingCell, morphism );
    
    return m;
    
end );

##
InstallMethod( AsCellOfPoset,
        "for a CAP object",
        [ IsCapCategoryObject ],
        
  function( object )
    local P, o;
    
    P := PosetOfCategory( CapCategory( object ) );
    
    o := rec( );
    
    ObjectifyObjectForCAPWithAttributes( o, P,
            UnderlyingCell, object );
    
    return o;
    
end );

##
InstallMethod( AsCellOfStablePoset,
        "for a CAP object",
        [ IsCapCategoryObject ],
        
  function( object )
    local P, o;
    
    P := StablePosetOfCategory( CapCategory( object ) );
    
    o := rec( );
    
    ObjectifyObjectForCAPWithAttributes( o, P,
            UnderlyingCell, object );
    
    return o;
    
end );

##
InstallMethod( AsCellOfPoset,
        "for a CAP morphism",
        [ IsCapCategoryMorphism ],
        
  function( morphism )
    local P, m;
    
    P := PosetOfCategory( CapCategory( morphism ) );
    
    m := rec( );
    
    ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( m, P,
            Source( morphism ) / P,
            Range( morphism ) / P,
            UnderlyingCell, morphism );
    
    return m;
    
end );

##
InstallMethod( AsCellOfStablePoset,
        "for a CAP morphism",
        [ IsCapCategoryMorphism ],
        
  function( morphism )
    local P, m;
    
    P := StablePosetOfCategory( CapCategory( morphism ) );
    
    m := rec( );
    
    ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( m, P,
            Source( morphism ) / P,
            Range( morphism ) / P,
            UnderlyingCell, morphism );
    
    return m;
    
end );

##
InstallMethod( \/,
        "for a CAP object",
        [ IsCapCategoryObject, IsProsetOrPosetOfCapCategory ],
        
  function( object, P )
    local o;
    
    if not IsIdenticalObj( CapCategory( object ), AmbientCategory( P ) ) then
        Error( "the category of the object and the ambient category of proset do not coincide\n" );
    fi;
    
    o := rec( );
    
    ObjectifyObjectForCAPWithAttributes( o, P,
            UnderlyingCell, object );
    
    return o;
    
end );

##
InstallMethod( \/,
        "for a CAP morphism",
        [ IsCapCategoryMorphism, IsProsetOrPosetOfCapCategory ],
        
  function( morphism, P )
    local m;
    
    if not IsIdenticalObj( CapCategory( morphism ), AmbientCategory( P ) ) then
        Error( "the category of the morphism and the ambient category of proset do not coincide\n" );
    fi;
    
    m := rec( );
    
    ObjectifyMorphismWithSourceAndRangeForCAPWithAttributes( m, P,
            Source( morphism ) / P,
            Range( morphism ) / P,
            UnderlyingCell, morphism );
    
    return m;
    
end );

##
InstallMethod( AmbientCategory,
        [ IsProsetOrPosetOfCapCategory ],
        
  function( A )
    
    return A!.AmbientCategory;
    
end );

##
InstallMethod( CreateProsetOrPosetOfCategory,
        "for a CAP category",
        [ IsCapCategory ],
        
  function( C )
    local skeletal, stable, category_filter, category_object_filter, category_morphism_filter,
          name, create_func_bool, create_func_object0, create_func_morphism0,
          create_func_object, create_func_morphism, create_func_universal_morphism,
          list_of_operations_to_install, is_limit, skip, func, pos,
          properties, preinstall, P, finalize;
    
    skeletal := CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "skeletal", false );
    
    if IsIdenticalObj( skeletal, true ) then
        name := "Poset";
        category_filter := IsPosetOfCapCategory;
        category_object_filter := IsCapCategoryObjectInPosetOfACategory;
        category_morphism_filter := IsCapCategoryMorphismInPosetOfACategory;
    else
        name := "Proset";
        category_filter := IsProsetOfCapCategory;
        category_object_filter := IsCapCategoryObjectInProsetOfACategory;
        category_morphism_filter := IsCapCategoryMorphismInProsetOfACategory;
    fi;
    
    stable := CAP_INTERNAL_RETURN_OPTION_OR_DEFAULT( "stable", false );
    
    if IsIdenticalObj( stable, true ) then
        
        if not (HasIsThinCategory( C ) and IsThinCategory( C )) then
            Error( "only compatible (co)closed monoidal structures of (co)cartesian *thin* categories can be stabilized\n" );
        fi;
        
        name := Concatenation( "Stable", name );
        category_object_filter := category_object_filter and IsCapCategoryCellInStableProsetOrPosetOfACategory;
        category_morphism_filter := category_morphism_filter and IsCapCategoryCellInStableProsetOrPosetOfACategory;
    fi;
    
    name := Concatenation( name, "( ", Name( C ), " )" );
    
    ## e.g., IsHomSetInhabited
    create_func_bool :=
      function( name, P )
        local oper;
        
        oper := ValueGlobal( name );
        
        return
          function( arg )
            
            return CallFuncList( oper, List( arg, UnderlyingCell ) );
            
        end;
        
    end;
    
    ## e.g., TerminalObject
    create_func_object0 :=
      function( name, P )
        local oper;
        
        oper := ValueGlobal( name );
        
        return
          function( )
            
            return oper( C ) / P;
            
          end;
          
      end;
    
    ## e.g., TerminalObjectFunctorial
    create_func_morphism0 :=
      function( name, P )
        local oper;
        
        oper := ValueGlobal( name );
        
        return
          function( P )
            
            return oper( P!.AmbientCategory ) / P;
            
          end;
          
      end;
    
    ## e.g., DirectProduct
    create_func_object :=
      function( name, P )
        local oper;
        
        oper := ValueGlobal( name );
        
        return ## a constructor for universal objects
          function( arg )
            
            return CallFuncList( oper, List( arg, UnderlyingCell ) ) / P;
            
          end;
          
      end;
    
    ## e.g., IdentityMorphism, PreCompose
    create_func_morphism :=
      function( name, P )
        local oper, type;
        
        oper := ValueGlobal( name );
        
        type := CAP_INTERNAL_METHOD_NAME_RECORD.(name).io_type;
        
        return
          function( arg )
            local src_trg, S, T;
            
            src_trg := CAP_INTERNAL_GET_CORRESPONDING_OUTPUT_OBJECTS( type, arg );
            
            S := src_trg[1];
            T := src_trg[2];
            
            return UniqueMorphism( S, T );
            
          end;
          
      end;
    
    ## e.g., UniversalMorphismIntoTerminalObjectWithGivenTerminalObject
    create_func_universal_morphism :=
      function( name, P )
        local info, oper, type;
        
        info := CAP_INTERNAL_METHOD_NAME_RECORD.(name);
        
        if not info.with_given_without_given_name_pair[2] = name then
            Error( name, " is not the constructor of a universal morphism with a given universal object\n" );
        fi;
        
        type := CAP_INTERNAL_METHOD_NAME_RECORD.(name).io_type;
        
        oper := ValueGlobal( name );
        
        return
          function( arg )
            local src_trg, S, T;
            
            src_trg := CAP_INTERNAL_GET_CORRESPONDING_OUTPUT_OBJECTS( type, arg );
            
            S := src_trg[1];
            T := src_trg[2];
            
            return UniqueMorphism( S, T );
            
        end;
        
    end;
    
    is_limit :=
      function( a )
        local entry;
        
        entry := CAP_INTERNAL_METHOD_NAME_RECORD.(a);
        
        if IsBound( entry.universal_type ) and entry.universal_type in [ "Limit", "limit", "Colimit", "colimit" ] then
            return true;
        fi;
        
        return false;
        
    end;

    ## P admits the same (co)limits as C,
    ## in fact, a weak (co)limit in C becomes a (co)limit in P
    list_of_operations_to_install := Filtered( ListInstalledOperationsOfCategory( C ), is_limit );
    
    list_of_operations_to_install :=
      Concatenation(
              Intersection(
                      CAP_INTERNAL_METHOD_NAME_LIST_FOR_PREORDERED_SET_OF_CATEGORY,
                      ListInstalledOperationsOfCategory( C ) ),
              list_of_operations_to_install );

    skip := [ 
              ];
    
    if IsIdenticalObj( stable, true ) then
        
        Add( list_of_operations_to_install, "IsTerminal" );
        
        Append( skip,
                [ "IsHomSetInhabited",
                  "InternalHomOnObjects",
                  "AreIsomorphicForObjectsIfIsHomSetInhabited",
                  ] );
    fi;
    
    for func in skip do
        
        pos := Position( list_of_operations_to_install, func );
        if not pos = fail then
            Remove( list_of_operations_to_install, pos );
        fi;
        
    od;
    
    properties := [ #"IsEnrichedOverCommutativeRegularSemigroup",
                    #"IsAbCategory",
                    "IsAdditiveCategory",
                    "IsPreAbelianCategory",
                    "IsAbelianCategory",
                    "IsMonoidalCategory",
                    "IsBraidedMonoidalCategory",
                    "IsSymmetricMonoidalCategory",
                    "IsClosedMonoidalCategory",
                    "IsSymmetricClosedMonoidalCategory",
                    "IsCartesianCategory",
                    "IsStrictCartesianCategory",
                    "IsCartesianClosedCategory",
                    "IsCocartesianCategory",
                    "IsStrictCocartesianCategory",
                    "IsCocartesianCoclosedCategory",
                    ];
    
    properties := Intersection( ListKnownCategoricalProperties( C ), properties );
    
    properties := List( properties, p -> [ p, ValueGlobal( p )( C ) ] );
    
    Add( properties, [ "IsThinCategory", true ] );
    
    if IsIdenticalObj( stable, true ) then
        Add( properties, [ "IsStableProset", true ] );
    fi;
    
    if IsIdenticalObj( skeletal, true ) then
        
        Add( properties, [ "IsSkeletalCategory", true ] );
        
        preinstall := [ ADD_COMMON_METHODS_FOR_POSETS ];
        
        if HasIsCartesianCategory( C ) and IsCartesianCategory( C ) then
            Add( properties, [ "IsStrictCartesianCategory", true ] );
            preinstall := [ ADD_COMMON_METHODS_FOR_MEET_SEMILATTICES ];
        fi;
        
        if HasIsCocartesianCategory( C ) and IsCocartesianCategory( C ) then
            Add( properties, [ "IsStrictCocartesianCategory", true ] );
            Add( preinstall, ADD_COMMON_METHODS_FOR_JOIN_SEMILATTICES );
        fi;
        
    else
        
        preinstall := [ ADD_COMMON_METHODS_FOR_PREORDERED_SETS ];
        
        if HasIsCartesianCategory( C ) and IsCartesianCategory( C ) then
            preinstall := [ ADD_COMMON_METHODS_FOR_CARTESIAN_PREORDERED_SETS ];
        fi;
        
        if HasIsCocartesianCategory( C ) and IsCocartesianCategory( C ) then
            Add( preinstall, ADD_COMMON_METHODS_FOR_COCARTESIAN_PREORDERED_SETS );
        fi;
        
    fi;
    
    P := CategoryConstructor( :
                 name := name,
                 category_filter := category_filter,
                 category_object_filter := category_object_filter,
                 category_morphism_filter := category_morphism_filter,
                 properties := properties,
                 preinstall := preinstall,
                 is_monoidal := HasIsMonoidalCategory( C ) and IsMonoidalCategory( C ),
                 list_of_operations_to_install := list_of_operations_to_install,
                 create_func_bool := create_func_bool,
                 create_func_object0 := create_func_object0,
                 create_func_morphism0 := create_func_morphism0,
                 create_func_object := create_func_object,
                 create_func_morphism := create_func_morphism,
                 create_func_universal_morphism := create_func_universal_morphism
                 );
    
    P!.AmbientCategory := C;
    
    if CanCompute( C, "IsWeakTerminal" ) then
        
        AddIsTerminal( P,
          function( S )
            
            return IsWeakTerminal( UnderlyingCell( S ) );
            
        end );
        
    fi;
    
    if CanCompute( C, "IsWeakInitial" ) then
        
        AddIsInitial( P,
          function( S )
            
            return IsWeakInitial( UnderlyingCell( S ) );
            
        end );
        
    fi;
    
    if IsIdenticalObj( stable, true ) then
        if CanCompute( C, "InternalHomOnObjects" ) then
            
            ADD_COMMON_METHODS_FOR_HEYTING_ALGEBRAS( P );
            
            ##
            AddInternalHomOnObjects( P,
              function( S, T )
                
                return StableInternalHom( UnderlyingCell( S ), UnderlyingCell( T ) ) / CapCategory( S );
                
            end );
            
            ## InternalHomOnMorphismsWithGivenInternalHoms is passed from the ambient Heyting algebra,
            ## its source are and target are not identical but equal to above (altered) internal Hom
            
            ##
            AddExponentialOnObjects( P,
              InternalHomOnObjects );
            
            ##
            AddExponentialOnMorphismsWithGivenExponentials( P,
              InternalHomOnMorphismsWithGivenInternalHoms );
            
        else
            
        fi;
        
    fi;
    
    finalize := ValueOption( "FinalizeCategory" );
    
    if finalize = false then
        
        return P;
        
    fi;
    
    Finalize( P );
    
    return P;
    
end );

##
InstallMethod( ProsetOfCategory,
        "for a CAP category",
        [ IsCapCategory ],
        
  CreateProsetOrPosetOfCategory );

##
InstallMethod( PosetOfCategory,
        "for a CAP category",
        [ IsCapCategory ],
        
  function( C )
    
    return CreateProsetOrPosetOfCategory( C : skeletal := true );
    
end );

##
InstallMethod( StableProsetOfCategory,
        "for a CAP category",
        [ IsCapCategory ],
        
  function( C )
    
    return ProsetOfCategory( C : stable := true );
    
end );

##
InstallMethod( StablePosetOfCategory,
        "for a CAP category",
        [ IsCapCategory ],
        
  function( C )
    
    return PosetOfCategory( C : stable := true );
    
end );

##################################
##
## View & Display
##
##################################

##
InstallMethod( ViewObj,
        [ IsCapCategoryObjectInProsetOfACategory ],
        
  function( a )
    
    Print( "An object in the proset given by: " );
    
    ViewObj( UnderlyingCell( a ) );
    
end );

##
InstallMethod( ViewObj,
        [ IsCapCategoryObjectInProsetOfACategory and IsCapCategoryCellInStableProsetOrPosetOfACategory ],
        
  function( a )
    
    Print( "An object in the stable proset given by: " );
    
    ViewObj( UnderlyingCell( a ) );
    
end );

##
InstallMethod( Display,
        [ IsCapCategoryObjectInProsetOfACategory ],
        
  function( a )
    
    Display( UnderlyingCell( a ) );
    
    Display( "\nAn object in the proset given by the above data" );
    
end );

##
InstallMethod( Display,
        [ IsCapCategoryObjectInProsetOfACategory and IsCapCategoryCellInStableProsetOrPosetOfACategory ],
        
  function( a )
    
    Display( UnderlyingCell( a ) );
    
    Display( "\nAn object in the stable proset given by the above data" );
    
end );

##
InstallMethod( ViewObj,
        [ IsCapCategoryObjectInPosetOfACategory ],
        
  function( a )
    
    Print( "An object in the poset given by: " );
    
    ViewObj( UnderlyingCell( a ) );
    
end );

##
InstallMethod( ViewObj,
        [ IsCapCategoryObjectInPosetOfACategory and IsCapCategoryCellInStableProsetOrPosetOfACategory ],
        
  function( a )
    
    Print( "An object in the stable poset given by: " );
    
    ViewObj( UnderlyingCell( a ) );
    
end );

##
InstallMethod( Display,
        [ IsCapCategoryObjectInPosetOfACategory ],
        
  function( a )
    
    Display( UnderlyingCell( a ) );
    
    Display( "\nAn object in the poset given by the above data" );
    
end );

##
InstallMethod( Display,
        [ IsCapCategoryObjectInPosetOfACategory and IsCapCategoryCellInStableProsetOrPosetOfACategory ],
        
  function( a )
    
    Display( UnderlyingCell( a ) );
    
    Display( "\nAn object in the stable poset given by the above data" );
    
end );

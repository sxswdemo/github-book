require.onError = (err) -> console.error err

ALOHA_PATH = 'http://wysiwhat.github.com/Aloha-Editor' # '../Aloha-Editor'

# Configure paths to all the JS libs
require.config

  # # Configure Library Locations
  paths:
    aloha: ALOHA_PATH + '/src/lib/aloha'




require ['atc/models'], (Models) ->
  Models.ALL_CONTENT.add
    id: 'test1'
    mediaType: 'text/x-module'
    title: 'Test Module'
    body: '<h1>Hello</h1>'

  Models.ALL_CONTENT.add
    id: 'test2'
    mediaType: 'text/x-module'
    title: 'Another Test Module'
    body: '<h1>Hello2</h1>'

  Models.ALL_CONTENT.add
    id: 'col1'
    mediaType: 'text/x-collection'
    title: 'Test Collection'
    navTree: [{class:'preface', id:"m42955", title:"Preface"
     },{class:'chapter', title:"Introduction: The Nature of Science and Physics","children":[
      {id:"m42119", title:"Introduction to Science and the Realm of Physics, Physical Quantities, and Units"},
      {id:"m42092", title:"Physics: An Introduction"},
      {id:"m42091", title:"Physical Quantities and Units"},
      {id:"m42120", title:"Accuracy, Precision, and Significant Figures"},
      {id:"m42121", title:"Approximation"}
    ]},{class:'chapter', title:"Kinematics","children":[
      {id:"m42122", title:"Introduction to One-Dimensional Kinematics"},
      {id:"m42033", title:"Displacement"},
      {id:"m42124", title:"Vectors, Scalars, and Coordinate Systems"},
      {id:"m42096", title:"Time, Velocity, and Speed"},
      {id:"m42100", title:"Acceleration"},
      {id:"m42099", title:"Motion Equations for Constant Acceleration in One Dimension"},
      {id:"m42125", title:"Problem-Solving Basics for One-Dimensional Kinematics"},
      {id:"m42102", title:"Falling Objects"},
      {id:"m42103", title:"Graphical Analysis of One-Dimensional Motion"}
    ]},{class:'chapter', title:"Two-Dimensional Kinematics","children":[
      {id:"m42126", title:"Introduction to Two-Dimensional Kinematics"},
      {id:"m42104", title:"Kinematics in Two Dimensions: An Introduction"},
      {id:"m42127", title:"Vector Addition and Subtraction: Graphical Methods"},
      {id:"m42128", title:"Vector Addition and Subtraction: Analytical Methods"},
      {id:"m42042", title:"Projectile Motion"},
      {id:"m42045", title:"Addition of Velocities"}
    ]},{class:'chapter', title:"Dynamics: Force and Newton's Laws of Motion","children":[
      {id:"m42129", title:"Introduction to Dynamics: Newton's Laws of Motion"},
      {id:"m42069", title:"Development of Force Concept"},
      {id:"m42130", title:"Newton's First Law of Motion: Inertia"},
      {id:"m42073", title:"Newton's Second Law of Motion: Concept of a System"},
      {id:"m42074", title:"Newton's Third Law of Motion: Symmetry in Forces"},
      {id:"m42075", title:"Normal, Tension, and Other Examples of Forces"},
      {id:"m42076", title:"Problem-Solving Strategies"},
      {id:"m42132", title:"Further Applications of Newton's Laws of Motion"},
      {id:"m42137", title:"Extended Topic: The Four Basic Forces: An Introduction"}
    ]},{class:'chapter', title:"Further Applications of Newton's Laws: Friction, Drag, and Elasticity","children":[
      {id:"m42138", title:"Introduction: Further Applications of Newton's Laws"},
      {id:"m42139", title:"Friction"},
      {id:"m42080", title:"Drag Forces"},
      {id:"m42081", title:"Elasticity: Stress and Strain"}
    ]},{class:'chapter', title:"Uniform Circular Motion and Gravitation","children":[
      {id:"m42140", title:"Introduction to Uniform Circular Motion and Gravitation"},
      {id:"m42083", title:"Rotation Angle and Angular Velocity"},
      {id:"m42084", title:"Centripetal Acceleration"},
      {id:"m42086", title:"Centripetal Force"},
      {id:"m42142", title:"Fictitious Forces and Non-inertial Frames: The Coriolis Force"},
      {id:"m42143", title:"Newton's Universal Law of Gravitation"},
      {id:"m42144", title:"Satellites and Kepler's Laws: An Argument for Simplicity"}
    ]},{class:'chapter', title:"Work, Energy, and Energy Resources","children":[
      {id:"m42145", title:"Introduction to Work, Energy, and Energy Resources"},
      {id:"m42146", title:"Work: The Scientific Definition"},
      {id:"m42147", title:"Kinetic Energy and the Work-Energy Theorem"},
      {id:"m42148", title:"Gravitational Potential Energy"},
      {id:"m42149", title:"Conservative Forces and Potential Energy"},
      {id:"m42150", title:"Nonconservative Forces"},
      {id:"m42151", title:"Conservation of Energy"},
      {id:"m42152", title:"Power"},
      {id:"m42153", title:"Work, Energy, and Power in Humans"},
      {id:"m42154", title:"World Energy Use"}
    ]},{class:'chapter', title:"Linear Momentum and Collisions","children":[
      {id:"m42155", title:"Introduction to Linear Momentum and Collisions"},
      {id:"m42156", title:"Linear Momentum and Force"},
      {id:"m42159", title:"Impulse"},
      {id:"m42162", title:"Conservation of Momentum"},
      {id:"m42163", title:"Elastic Collisions in One Dimension"},
      {id:"m42164", title:"Inelastic Collisions in One Dimension"},
      {id:"m42165", title:"Collisions of Point Masses in Two Dimensions"},
      {id:"m42166", title:"Introduction to Rocket Propulsion"}
    ]},{class:'chapter', title:"Statics and Torque","children":[
      {id:"m42167", title:"Introduction to Statics and Torque"},
      {id:"m42170", title:"The First Condition for Equilibrium"},
      {id:"m42171", title:"The Second Condition for Equilibrium"},
      {id:"m42172", title:"Stability"},
      {id:"m42173", title:"Applications of Statics, Including Problem-Solving Strategies"},
      {id:"m42174", title:"Simple Machines"},
      {id:"m42175", title:"Forces and Torques in Muscles and Joints"}
    ]},{class:'chapter', title:"Rotational Motion and Angular Momentum","children":[
      {id:"m42176", title:"Introduction to Rotational Motion and Angular Momentum"},
      {id:"m42177", title:"Angular Acceleration"},
      {id:"m42178", title:"Kinematics of Rotational Motion"},
      {id:"m42179", title:"Dynamics of Rotational Motion: Rotational Inertia"},
      {id:"m42180", title:"Rotational Kinetic Energy: Work and Energy Revisited"},
      {id:"m42182", title:"Angular Momentum and Its Conservation"},
      {id:"m42183", title:"Collisions of Extended Bodies in Two Dimensions"},
      {id:"m42184", title:"Gyroscopic Effects: Vector Aspects of Angular Momentum"}
    ]},{class:'chapter', title:"Fluid Statics","children":[
      {id:"m42185", title:"Introduction to Fluid Statics"},
      {id:"m42186", title:"What Is a Fluid?"},
      {id:"m42187", title:"Density"},
      {id:"m42189", title:"Pressure"},
      {id:"m42192", title:"Variation of Pressure with Depth in a Fluid"},
      {id:"m42193", title:"Pascal's Principle"},
      {id:"m42195", title:"Gauge Pressure, Absolute Pressure, and Pressure Measurement"},
      {id:"m42196", title:"Archimedes' Principle"},
      {id:"m42197", title:"Cohesion and Adhesion in Liquids: Surface Tension and Capillary Action"},
      {id:"m42199", title:"Pressures in the Body"}
    ]},{class:'chapter', title:"Fluid Dynamics and Its Biological and Medical Applications","children":[
      {id:"m42204", title:"Introduction to Fluid Dynamics and Its Biological and Medical Applications"},
      {id:"m42205", title:"Flow Rate and Its Relation to Velocity"},
      {id:"m42206", title:"Bernoulli's Equation"},
      {id:"m42208", title:"The Most General Applications of Bernoulli's Equation"},
      {id:"m42209", title:"Viscosity and Laminar Flow; Poiseuille's Law"},
      {id:"m42210", title:"The Onset of Turbulence"},
      {id:"m42211", title:"Motion of an Object in a Viscous Fluid"},
      {id:"m42212", title:"Molecular Transport Phenomena: Diffusion, Osmosis, and Related Processes"}
    ]},{class:'chapter', title:"Temperature, Kinetic Theory, and the Gas Laws","children":[
      {id:"m42213", title:"Introduction to Temperature, Kinetic Theory, and the Gas Laws"},
      {id:"m42214", title:"Temperature"},
      {id:"m42215", title:"Thermal Expansion of Solids and Liquids"},
      {id:"m42216", title:"The Ideal Gas Law"},
      {id:"m42217", title:"Kinetic Theory: Atomic and Molecular Explanation of Pressure and Temperature"},
      {id:"m42218", title:"Phase Changes"},
      {id:"m42219", title:"Humidity, Evaporation, and Boiling"}
    ]},{class:'chapter', title:"Heat and Heat Transfer Methods","children":[
      {id:"m42221", title:"Introduction to Heat and Heat Transfer Methods"},
      {id:"m42223", title:"Heat"},
      {id:"m42224", title:"Temperature Change and Heat Capacity"},
      {id:"m42225", title:"Phase Change and Latent Heat"},
      {id:"m42226", title:"Heat Transfer Methods"},
      {id:"m42228", title:"Conduction"},
      {id:"m42229", title:"Convection"},
      {id:"m42230", title:"Radiation"}
    ]},{class:'chapter', title:"Thermodynamics","children":[
      {id:"m42231", title:"Introduction to Thermodynamics"},
      {id:"m42232", title:"The First Law of Thermodynamics"},
      {id:"m42233", title:"The First Law of Thermodynamics and Some Simple Processes"},
      {id:"m42234", title:"Introduction to the Second Law of Thermodynamics: Heat Engines and Their Efficiency"},
      {id:"m42235", title:"Carnot's Perfect Heat Engine: The Second Law of Thermodynamics Restated"},
      {id:"m42236", title:"Applications of Thermodynamics: Heat Pumps and Refrigerators"},
      {id:"m42237", title:"Entropy and the Second Law of Thermodynamics: Disorder and the Unavailability of Energy"},
      {id:"m42238", title:"Statistical Interpretation of Entropy and the Second Law of Thermodynamics: The Underlying Explanation"}
    ]},{class:'chapter', title:"Oscillatory Motion and Waves","children":[
      {id:"m42239", title:"Introduction to Oscillatory Motion and Waves"},
      {id:"m42240", title:"Hooke's Law: Stress and Strain Revisited"},
      {id:"m42241", title:"Period and Frequency in Oscillations"},
      {id:"m42242", title:"Simple Harmonic Motion: A Special Periodic Motion"},
      {id:"m42243", title:"The Simple Pendulum"},
      {id:"m42244", title:"Energy and the Simple Harmonic Oscillator"},
      {id:"m42245", title:"Uniform Circular Motion and Simple Harmonic Motion"},
      {id:"m42246", title:"Damped Harmonic Motion"},
      {id:"m42247", title:"Forced Oscillations and Resonance"},
      {id:"m42248", title:"Waves"},
      {id:"m42249", title:"Superposition and Interference"},
      {id:"m42250", title:"Energy in Waves: Intensity"}
    ]},{class:'chapter', title:"Physics of Hearing","children":[
      {id:"m42254", title:"Introduction to the Physics of Hearing"},
      {id:"m42255", title:"Sound"},
      {id:"m42256", title:"Speed of Sound, Frequency, and Wavelength"},
      {id:"m42257", title:"Sound Intensity and Sound Level"},
      {id:"m42712", title:"Doppler Effect and Sonic Booms"},
      {id:"m42296", title:"Sound Interference and Resonance: Standing Waves in Air Columns"},
      {id:"m42297", title:"Hearing"},
      {id:"m42298", title:"Ultrasound"}
    ]},{class:'chapter', title:"Electric Charge and Electric Field","children":[
      {id:"m42299", title:"Introduction to Electric Charge and Electric Field"},
      {id:"m42300", title:"Static Electricity and Charge: Conservation of Charge"},
      {id:"m42306", title:"Conductors and Insulators"},
      {id:"m42308", title:"Coulomb's Law"},
      {id:"m42310", title:"Electric Field: Concept of a Field Revisited"},
      {id:"m42312", title:"Electric Field Lines: Multiple Charges"},
      {id:"m42315", title:"Electric Forces in Biology"},
      {id:"m42317", title:"Conductors and Electric Fields in Static Equilibrium"},
      {id:"m42329", title:"Applications of Electrostatics"}
    ]},{class:'chapter', title:"Electric Potential and Electric Field","children":[
      {id:"m42320", title:"Introduction to Electric Potential and Electric Energy"},
      {id:"m42324", title:"Electric Potential Energy: Potential Difference"},
      {id:"m42326", title:"Electric Potential in a Uniform Electric Field"},
      {id:"m42328", title:"Electrical Potential Due to a Point Charge"},
      {id:"m42331", title:"Equipotential Lines"},
      {id:"m42333", title:"Capacitors and Dielectrics"},
      {id:"m42336", title:"Capacitors in Series and Parallel"},
      {id:"m42395", title:"Energy Stored in Capacitors"}
    ]},{class:'chapter', title:"Electric Current, Resistance, and Ohm's Law","children":[
      {id:"m42339", title:"Introduction to Electric Current, Resistance, and Ohm's Law"},
      {id:"m42341", title:"Current"},
      {id:"m42344", title:"Ohm's Law: Resistance and Simple Circuits"},
      {id:"m42346", title:"Resistance and Resistivity"},
      {id:"m42714", title:"Electric Power and Energy"},
      {id:"m42348", title:"Alternating Current versus Direct Current"},
      {id:"m42350", title:"Electric Hazards and the Human Body"},
      {id:"m42352", title:"Nerve Conduction: Electrocardiograms"}
    ]},{class:'chapter', title:"Circuits, Bioelectricity, and DC Instruments","children":[
      {id:"m42354", title:"Introduction to Circuits, Bioelectricity, and DC Instruments"},
      {id:"m42356", title:"Resistors in Series and Parallel"},
      {id:"m42357", title:"Electromotive Force: Terminal Voltage"},
      {id:"m42359", title:"Kirchhoff's Rules"},
      {id:"m42360", title:"DC Voltmeters and Ammeters"},
      {id:"m42362", title:"Null Measurements"},
      {id:"m42363", title:"DC Circuits Containing Resistors and Capacitors"}
    ]},{class:'chapter', title:"Magnetism","children":[
      {id:"m42365", title:"Introduction to Magnetism"},
      {id:"m42366", title:"Magnets"},
      {id:"m42368", title:"Ferromagnets and Electromagnets"},
      {id:"m42370", title:"Magnetic Fields and Magnetic Field Lines"},
      {id:"m42372", title:"Magnetic Field Strength: Force on a Moving Charge in a Magnetic Field"},
      {id:"m42375", title:"Force on a Moving Charge in a Magnetic Field: Examples and Applications"},
      {id:"m42377", title:"The Hall Effect"},
      {id:"m42398", title:"Magnetic Force on a Current-Carrying Conductor"},
      {id:"m42380", title:"Torque on a Current Loop: Motors and Meters"},
      {id:"m42382", title:"Magnetic Fields Produced by Currents: Ampere's Law"},
      {id:"m42386", title:"Magnetic Force between Two Parallel Conductors"},
      {id:"m42388", title:"More Applications of Magnetism"}
    ]},{class:'chapter', title:"Electromagnetic Induction, AC Circuits, and Electrical Technologies","children":[
      {id:"m42389", title:"Introduction to Electromagnetic Induction, AC Circuits and Electrical Technologies"},
      {id:"m42390", title:"Induced Emf and Magnetic Flux"},
      {id:"m42392", title:"Faraday's Law of Induction: Lenz's Law"},
      {id:"m42400", title:"Motional Emf"},
      {id:"m42404", title:"Eddy Currents and Magnetic Damping"},
      {id:"m42408", title:"Electric Generators"},
      {id:"m42411", title:"Back Emf"},
      {id:"m42414", title:"Transformers"},
      {id:"m42416", title:"Electrical Safety: Systems and Devices"},
      {id:"m42420", title:"Inductance"},
      {id:"m42425", title:"RL Circuits"},
      {id:"m42427", title:"Reactance, Inductive and Capacitive"},
      {id:"m42431", title:"RLC Series AC Circuits"}
    ]},{class:'chapter', title:"Electromagnetic Waves","children":[
      {id:"m42434", title:"Introduction to Electromagnetic Waves"},
      {id:"m42437", title:"Maxwell's Equations: Electromagnetic Waves Predicted and Observed"},
      {id:"m42440", title:"Production of Electromagnetic Waves"},
      {id:"m42444", title:"The Electromagnetic Spectrum"},
      {id:"m42446", title:"Energy in Electromagnetic Waves"}
    ]},{class:'chapter', title:"Geometric Optics","children":[
      {id:"m42449", title:"Introduction to Geometric Optics"},
      {id:"m42452", title:"The Ray Aspect of Light"},
      {id:"m42456", title:"The Law of Reflection"},
      {id:"m42459", title:"The Law of Refraction"},
      {id:"m42462", title:"Total Internal Reflection"},
      {id:"m42466", title:"Dispersion: The Rainbow and Prisms"},
      {id:"m42470", title:"Image Formation by Lenses"},
      {id:"m42474", title:"Image Formation by Mirrors"}
    ]},{class:'chapter', title:"Vision and Optical Instruments","children":[
      {id:"m42478", title:"Introduction to Vision and Optical Instruments"},
      {id:"m42482", title:"Physics of the Eye"},
      {id:"m42484", title:"Vision Correction"},
      {id:"m42487", title:"Color and Color Vision"},
      {id:"m42491", title:"Microscopes"},
      {id:"m42493", title:"Telescopes"},
      {id:"m42292", title:"Aberrations"}
    ]},{class:'chapter', title:"Wave Optics","children":[
      {id:"m42496", title:"Introduction to Wave Optics"},
      {id:"m42501", title:"The Wave Aspect of Light: Interference"},
      {id:"m42505", title:"Huygens's Principle: Diffraction"},
      {id:"m42508", title:"Young's Double Slit Experiment"},
      {id:"m42512", title:"Multiple Slit Diffraction"},
      {id:"m42515", title:"Single Slit Diffraction"},
      {id:"m42517", title:"Limits of Resolution: The Rayleigh Criterion"},
      {id:"m42519", title:"Thin Film Interference"},
      {id:"m42522", title:"Polarization"},
      {id:"m42290", title:"*Extended Topic* Microscopy Enhanced by the Wave Characteristics of Light"}
    ]},{class:'chapter', title:"Special Relativity","children":[
      {id:"m42525", title:"Introduction to Special Relativity"},
      {id:"m42528", title:"Einstein's Postulates"},
      {id:"m42531", title:"Simultaneity And Time Dilation"},
      {id:"m42535", title:"Length Contraction"},
      {id:"m42540", title:"Relativistic Addition of Velocities"},
      {id:"m42542", title:"Relativistic Momentum"},
      {id:"m42546", title:"Relativistic Energy"}
    ]},{class:'chapter', title:"Introduction to Quantum Physics","children":[
      {id:"m42550", title:"Introduction to Quantum Physics"},
      {id:"m42554", title:"Quantization of Energy"},
      {id:"m42558", title:"The Photoelectric Effect"},
      {id:"m42563", title:"Photon Energies and the Electromagnetic Spectrum"},
      {id:"m42568", title:"Photon Momentum"},
      {id:"m42573", title:"The Particle-Wave Duality"},
      {id:"m42576", title:"The Wave Nature of Matter"},
      {id:"m42579", title:"Probability: The Heisenberg Uncertainty Principle"},
      {id:"m42581", title:"The Particle-Wave Duality Reviewed"}
    ]},{class:'chapter', title:"Atomic Physics","children":[
      {id:"m42585", title:"Introduction to Atomic Physics"},
      {id:"m42589", title:"Discovery of the Atom"},
      {id:"m42592", title:"Discovery of the Parts of the Atom: Electrons and Nuclei"},
      {id:"m42596", title:"Bohr's Theory of the Hydrogen Atom"},
      {id:"m42599", title:"X Rays: Atomic Origins and Applications"},
      {id:"m42602", title:"Applications of Atomic Excitations and De-Excitations"},
      {id:"m42606", title:"The Wave Nature of Matter Causes Quantization"},
      {id:"m42609", title:"Patterns in Spectra Reveal More Quantization"},
      {id:"m42614", title:"Quantum Numbers and Rules"},
      {id:"m42618", title:"The Pauli Exclusion Principle"}
    ]},{class:'chapter', title:"Radioactivity and Nuclear Physics","children":[
      {id:"m42620", title:"Introduction to Radioactivity and Nuclear Physics"},
      {id:"m42623", title:"Nuclear Radioactivity"},
      {id:"m42627", title:"Radiation Detection and Detectors"},
      {id:"m42631", title:"Substructure of the Nucleus"},
      {id:"m42633", title:"Nuclear Decay and Conservation Laws"},
      {id:"m42636", title:"Half-Life and Activity"},
      {id:"m42640", title:"Binding Energy"},
      {id:"m42644", title:"Tunneling"}
    ]},{class:'chapter', title:"Medical Applications of Nuclear Physics","children":[
      {id:"m42646", title:"Introduction to Applications of Nuclear Physics"},
      {id:"m42649", title:"Medical Imaging and Diagnostics"},
      {id:"m42652", title:"Biological Effects of Ionizing Radiation"},
      {id:"m42654", title:"Therapeutic Uses of Ionizing Radiation"},
      {id:"m42656", title:"Food Irradiation"},
      {id:"m42659", title:"Fusion"},
      {id:"m42662", title:"Fission"},
      {id:"m42665", title:"Nuclear Weapons"}
    ]},{class:'chapter', title:"Particle Physics","children":[
      {id:"m42667", title:"Introduction to Particle Physics"},
      {id:"m42669", title:"The Yukawa Particle and the Heisenberg Uncertainty Principle Revisited"},
      {id:"m42671", title:"The Four Basic Forces"},
      {id:"m42718", title:"Accelerators Create Matter from Energy"},
      {id:"m42674", title:"Particles, Patterns, and Conservation Laws"},
      {id:"m42678", title:"Quarks: Is That All There Is?"},
      {id:"m42680", title:"GUTs: The Unification of Forces"}
    ]},{class:'chapter', title:"Frontiers of Physics","children":[
      {id:"m42683", title:"Introduction to Frontiers of Physics"},
      {id:"m42686", title:"Cosmology and Particle Physics"},
      {id:"m42689", title:"General Relativity and Quantum Gravity"},
      {id:"m42691", title:"Superstrings"},
      {id:"m42692", title:"Dark Matter and Closure"},
      {id:"m42694", title:"Complexity and Chaos"},
      {id:"m42696", title:"High-temperature Superconductors"},
      {id:"m42704", title:"Some Questions We Know to Ask"}]},{id:"m42699", title:"Atomic Masses"},
      {id:"m42702", title:"Selected Radioactive Isotopes"},
      {id:"m42720", title:"Useful Information"},
      {id:"m42709", title:"Glossary of Key Symbols and Notation"}]


  Models.SearchResults = Models.SearchResults.extend
    initialize: ->
      for model in Models.ALL_CONTENT.models
        if model.get('mediaType') != 'text/x-module'
          @add model, {at: 0}
        else
          @add model

  # SEt the loaded flag so we don't try and populate them from the server
  Models.ALL_CONTENT.each (model) -> model.loaded = true

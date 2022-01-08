PBS Templates

Templates are used by Anubis to generate PBS input to schedule a job on the remote system. Anubis will replace the reserved variables automatically with corresponding inputs in case definition.

A PBS is generated for each Anubis iteration as location of case files on remote server varies from iteration to iteration.

Reserved variables:

General:
*NODECOUNT*	: number of nodes
*CORECOUNT* 	: number of cores per node
*JOBTITLE*  	: title of the job on the PBS scheduling system
*WALLTIME*  	: maximum run time in hours
*MODULENAME*	: name of simulation module on system

StarCCM:
*CCMFILE*	: StarCCM input file on remote server
*ANUBISJAVAPATH*: anubis.java location on remote server
*LICENSEPATH*	: address of StarCCM license server

MCNP:
*MCNPFILE*	: MCNP input file on remote server

OpenFOAM:
*FOAMCASE*	: OpenFOAM active case directory on remote server
*FOAMSOLVER*	: OpenFOAM solver specified in controlDict

These templates are provided as examples. They may not work on every system (e.g. you may need to load other modules or define different index sources).

Acknowledgments: UNM CARC is acknowledged for their support.
# Anubis 
Author: Khaled Talaat (PhD Candidate in nuclear engineering at the University of New Mexico, Albuquerque)
# Scope
External coupling of steady state Monte Carlo neutron transport and computational fluid dynamics (CFD) for nuclear energy research applications. 
# Purpose
Anubis is a semi-modular, geometry-blind, and multi-server loose coupling utility that iteratively maps temperature and energy field effects between MCNP6 and OpenFOAM or STAR-CCM+ until convergence criteria are met. More specifically, Anubis transfers the steady state unnormalized prompt power profile from MCNP to CFD and uses the calculated temperature field from CFD to update the cross-section library, densities, and surface parameters in MCNP based on pre-defined user input. Anubis jobs can be local, entirely remote on one or more servers, or hybrid (i.e. it can run one program locally and one program remotely).
# Compatibility and Prerequisites
• Anubis is compatible with Windows 10 and Linux (tested on Ubuntu locally and remotely on CentOS). Mac is not supported.<br />
• MATLAB R2021b or later release is required. Remote coupling in Anubis is not compatible with older version of MATLAB that did not directly support SFTP. <br />
• MCNP6, OpenFOAM, and STAR-CCM+ are not distributed with Anubis. You need MCNP6 and either of OpenFOAM or STAR-CCM+.<br />
• MCNP6 is an export-controlled code. If you do not have MCNP, please see https://mcnp.lanl.gov/mcnp_how_to_get_to_mcnp.shtml. <br />
• Anubis has been tested with MCNP6.1. Older versions of MCNP are not supported.<br />
• Anubis is compatible with the chtMultiRegionFoam conjugate heat transfer solver in OpenFOAM 9 and OpenFOAM for Windows distributed by CFD Support (https://www.cfdsupport.com/openfoam-for-windows.html).<br />
• SSHPASS is required for local runs of STAR-CCM+ on Linux.<br />
• To run jobs on remote servers, you must set up key based authentication by copying your RSA public key to authorized_keys in the remote host (see https://www.adminschoice.com/how-to-configure-ssh-without-password). Basically run ssh-keygen -t rsa and copy key from users/[yourusername]/.ssh folder to your .ssh/authorized_keys on your other machine and make sure that you are the only owner of all directories above .ssh starting from your own user directory and you must be the only one with write permission. If a folder is assigned group permission to write, remote connection will not work.<br />
• The remote server must use a Portable Batch System (PBS) for job scheduling. MATLAB is not required on the remote server. You only need to run Anubis on the client.<br />
# Setup
• No installation is required. Just add Anubis and all sub-folders to your MATLAB path.
• Make sure all prerequisites to features that you are using are installed and default Bash aliases are defined.
# Demo Video
https://www.youtube.com/watch?v=ryh8aY8VFNo
# Examples
Multiple examples are provided with the code for demonstration. You will find cases with local, remote, and hybrid coupling. These examples are not intended to represent problems of practical engineering or physics interest but rather serve to allow you to test the code and understand the required inputs.
# Verification
Anubis does not introduce new physics or math. Anubis is effectively a robust data transfer platform that replaces the tedious manual labor in coupling of MCNP with CFD codes which has long followed a similar scheme. Anubis has been extensively tested with dozens of MCNP, OpenFOAM, and STAR-CCM+ input files to verify its input parsing capability. It has also been verified that Anubis correctly manipulates MCNP cell cards, surface parameters, and materials cards consistent with the described flow chart and user-specified surface expansion and density correction equations as a function of cell temperature calculated from coupling with regions in CFD. JAVA macros generated by Anubis to control STAR-CCM+ simulations, extract output, and update power have also been rigorously examined. For OpenFOAM 9, Anubis correctly reads the input and updates fvOptions for each region with the power calculated from Equation 3 in the user manual. You can conduct your independent verification by examining the output files for a simple example such as the cylinder example provided and compare with expected values based on MCNP and CFD outputs and specified equations in Anubis input files. Physical accuracy of the solution, on the other hand, largely depends on the CFD models employed, cross-section data and accuracy of material properties used, statistical uncertainties of the Monte Carlo solution, and, applicability of the steady state coupling scheme employed in Anubis to the problem.
# Liability
Anubis is a research code. It is not intended for industrial application. No warranty or liability for any damages is assumed. You are expected to read and understand the source code and adapt it to your needs if necessary. Do not use the code if you do not agree to this term.
# Statement on Cyber Security
As with any code with capability to transfer data from and to a remote system, cyber security can be a concern. While Anubis uses reliable and secure protocols such as SFTP and SSH, there is no guarantee that Anubis overall offers a secure environment. You are encouraged to consult with your IT team to evaluate the use of the code especially if you deal with sensitive information on the local or remote server(s). No information you provide in Anubis input is collected or transmitted to other parties besides the remote servers you specify in the input files. Passwords and other specified information are encrypted when transmitted to the remote servers that you specify. As some passwords for remote access and local access may be stored in input text files on your computer, it is recommended that you delete the files or redact the sensitive information after the Anubis runs are done and only use Anubis in work environments where you have exclusive access to the computer. Passwords are specified in input files as text instead of being passed as arguments to Anubis because different combinations of remote/local coupling options are possible (e.g. you can run MCNP locally and OpenFOAM/STAR-CCM+ remotely, or MCNP remotely and OpenFOAM/STAR-CCM+ locally, or both remotely on the same or different servers, or both locally). Nevertheless, you have the full right to modify the code as necessary for your needs. 

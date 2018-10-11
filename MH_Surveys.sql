
/******************************************************************/
CREATE FUNCTION MH_Survey (@sta3n smallint)
RETURNS TABLE
AS
	RETURN
		SELECT DISTINCT
			SPatient.PatientSID
			,SPatient.Sta3n
			,SAddress.GISPatientAddressLongitude
			,SAddress.GISPatientAddressLatitude
			,MHS.SurveyName
			,MHS.RawScore
			,MHS.SurveyGivenDateTime
		FROM
			LSV.BISL_R1VX.AR3Y_SPatient_SPatient AS SPatient
			INNER JOIN LSV.SPatient.SPatientAddress AS SAddress
				ON SPatient.PatientSID = SAddress.PatientSID
				AND SPatient.Sta3n = SAddress.Sta3n
			INNER JOIN LSV.MH.SurveyResult AS MHS
				ON SAddress.PatientSID = MHS.PatientSID
				AND SAddress.Sta3n = MHS.Sta3n
		WHERE
			SPatient.Sta3n = @sta3n
			AND SPatient.TestPatientFlag IS NULL
			AND SAddress.RelationshipToPatient = 'SELF'
			AND SAddress.AddressType = 'PATIENT'
			AND MHS.SurveyName IN ('PHQ9', 'PCL-5');
GO
/*
SELECT TOP (42)
	*
	--available columns
	PatientSID
	Sta3n
	GISPatientAddressLongitude
	GISPatientAddressLatitude
	SurveyName
	RawScore
	SurveyGivenDateTime

FROM
	MH_Survey(612);
GO

DROP FUNCTION MH_Survey;
GO
*/
/******************************************************************/

USE LSV
SELECT
	*
FROM
	MH_Survey(612)
ORDER BY
	PatientSID, SurveyGivenDateTime;
select cf.cfname,cfo.CUSTOMFIELD,cfo.CUSTOMFIELDCONFIG,cfo.customvalue,cfo.PARENTOPTIONID,cfo.SEQUENCE,cfo.optiontype FROM customfieldoption  cfo
JOIN customfield cf ON cfo.CUSTOMFIELD = cf.ID
WHERE cfo.CUSTOMFIELD in (11811) 
ORDER BY cfo.CUSTOMFIELD,cfo.SEQUENCE,cfo.PARENTOPTIONID ASC

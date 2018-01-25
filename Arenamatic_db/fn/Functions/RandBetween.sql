CREATE FUNCTION fn.RandBetween( @bottom INTEGER, 
                                @top    INTEGER) 
RETURNS INTEGER 
AS 
  BEGIN 
      RETURN 
        (SELECT Cast(Round(( @top - @bottom ) * randomnumber + @bottom, 0) AS
                     INTEGER) 
         FROM   dbo.v_randomnumber) 
  END 


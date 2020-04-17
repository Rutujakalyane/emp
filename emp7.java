public class emp7 {
	//CONSTANTS
	int IS_PART_TIME = 1;
	int IS_FULL_TIME = 2;
	int EMP_RATE_PER_HOUR = 20;
	int NUM_OF_WORKING_DAYS = 20;
	int MAX_HRS_IN_MONTH = 100;

	public static int calTotalEmpWage( int totalEmpHrs )	{
		return totalEmpHrs * EMP_RATE_PER_HOUR;
	}

	public static void main(String args[]) {
		//VARIABLES
		int empHrs = 0, totalEmpHrs = 0, totalWorkingDays = 0;
		//COMPUTATION
		while ( totalEmpHrs <= MAX_HRS_IN_MONTH &&
				totalWorkingDays < NUM_OF_WORKING_DAYS )	{
			totalWorkingDays++;
			int empCheck = (int) ( Math.random() * 10 ) % 3;
			switch (empCheck)	{
				case IS_PART_TIME:
					empHrs = 4;
					break;
				case IS_FULL_TIME:
					empHrs = 8;
					break;
				default:
					empHrs = 0;
			}
			totalEmpHrs += empHrs;
			System.out.println("Day#: " + totalWorkingDays + " Emp Hr: " +  empHrs);
		}
		int totalEmpWage = calTotalEmpWage( totalEmpHrs );
		System.out.println("Total Emp Wage: " + totalEmpWage);
	}
}

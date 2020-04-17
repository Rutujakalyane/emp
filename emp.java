public class emp {
        //CONSTANTS
        public static final int IS_PART_TIME = 1;
        public static final int IS_FULL_TIME = 2;
        public static int EMP_RATE_PER_HOUR;
        public static int NUM_OF_WORKING_DAYS;
        public static int MAX_HRS_IN_MONTH;

        //CONSTRUCTOR
        public emp( int EMP_RATE_PER_HOUR, int NUM_OF_WORKING_DAYS, int MAX_HRS_IN_MONTH )      {
                this.EMP_RATE_PER_HOUR = EMP_RATE_PER_HOUR;
                this.NUM_OF_WORKING_DAYS = NUM_OF_WORKING_DAYS;
                this.MAX_HRS_IN_MONTH = MAX_HRS_IN_MONTH;
        }

        //COMPUTATION
        public static int computeTotalEmpHrs()  {
                int empHrs = 0, totalEmpHrs = 0, totalWorkingDays = 0;
                while( totalEmpHrs <= MAX_HRS_IN_MONTH && totalWorkingDays < NUM_OF_WORKING_DAYS )
                {
                        totalWorkingDays++;
                        int empCheck = (int) ( Math.random() * 10 ) % 3;
                        switch (empCheck) {
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
                return totalEmpHrs;
        }

        //CALCULATING TOTAL EMPLOYEE WAGE
        public int calTotalEmpWage( int totalEmpHrs )   {
                return totalEmpHrs * EMP_RATE_PER_HOUR;
        }


        public static void main(String args[]) {
                //CREATING OBJECTS FOR COMPANY
                EmpWageComputation bridgelabz = new EmpWageComputation( 20, 20, 100 );
                int bridgelabzTotalEmpHrs = bridgelabz.computeTotalEmpHrs();
                int totalBridgelabzEmpWage = bridgelabz.calTotalEmpWage( bridgelabzTotalEmpHrs );
                System.out.println("Total Wage of Bridgelabz Employee: " + totalBridgelabzEmpWage);

                EmpWageComputation google = new EmpWageComputation( 50, 15, 75 );
                int googleTotalEmpHrs = google.computeTotalEmpHrs();
                int totalGoogleEmpWage = google.calTotalEmpWage( googleTotalEmpHrs );
                System.out.println("Total Wage of Google Employee: " + totalGoogleEmpWage );
        }
}

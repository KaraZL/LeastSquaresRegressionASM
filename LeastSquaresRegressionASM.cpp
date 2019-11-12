// LeastSquaresRegressionASM.cpp : Ce fichier contient la fonction 'main'. L'exécution du programme commence et se termine à cet endroit.
//

#include <iostream>

extern "C" bool LeastSquares(const double* x, const double* y, int n, double* m, double* b);

int main()
{
	const int n = 5;
	double x[n] = { 2,3,5,7,9 };
	double y[n] = { 4,5,7,10,15 };

	double m = 0;
	double b = 0;

	bool result = LeastSquares(x, y, n, &m, &b);

	for (unsigned int i = 0; i < n; i++) {
		std::cout << "x : " << x[i] << " y : " << y[i] << std::endl;
		
	}

	std::cout << "m : " << m << " b : " << b << std::endl;


	return 0;
}

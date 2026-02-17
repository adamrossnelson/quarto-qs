# Maximizing Reproducibility

As you add data, filter data, subset data, or otherwise transform data the results of your analysis may change. Consider the following example that produces and describes a correct result, but that would not correctly update if alternate date preparations changed the results.

## Setup

```{python}
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import chi2_contingency
from IPython.display import Markdown, display

tips = sns.load_dataset('tips')
```

## Analysis (Not Highly Reproducible)

```{python}
# RQ: Is there a relationship between day of the week and smoking status?
chi2, p_value, dof, expected = chi2_contingency(
    pd.crosstab(tips['day'], tips['smoker'])
)

# Returning p_value < 0.0500
conclusion = "These results suggest that there is a relatinship between the day of the week and the patron's smoking preference."

dispay(Markdown(conclusion))
```

The expected output from this reproducible code block is:

> A Chi-squared test of independence finds a Chi-Squared statistic that can be used to evaluate the relationship between two categorical variables. These results (p <= 0.00001057, Ch2=25.7872) suggest that there is a relatinship between the day of the week and the patron's smoking preference.

However if new data, more data, differently filtered data, went through the same code block and also produced a higher p-value (greater than 0.05) then the output of the code would approximate the following:

> A Chi-squared test of independence finds a Chi-Squared statistic that can be used to evaluate the relationship between two categorical variables. These results (p = 0.23990000, Ch2=4.25670000) suggest that there is no relatinship between the day of the week and the patron's smoking preference.

# The Case For These Additional Efforts

Writing code that handles both outcomes (significant and not significant, expected and unexpected—takes more time upfront. It is tempting to skip this work. After all, you already know what the result is. You ran the analysis, you saw the p-value, and you wrote a sentence that describes it. Why bother coding out the alternative?

The answer is that a Quarto document is not a static report. It is a living program. Every time you render it, the code runs again from scratch. That is the entire point. And anything that runs again can produce a different result.

## Data Changes More Often Than You Think

Datasets grow. Filters get revised. A colleague notices duplicate records and removes them. A new quarter of data arrives. An upstream data provider corrects an error. In each of these cases, the numbers change. If your prose is hard-coded to describe one specific outcome, the document will render without error but will now contain a statement that contradicts its own tables and figures. The reader has no way to know which is correct—the text or the numbers. This is worse than a crash. A crash tells you something is wrong. A silently incorrect narrative does not.

## Quarto Makes This Easy

The `display(Markdown(...))` pattern shown above is lightweight. You build a string with f-string interpolation, branch on a condition, and display the result. Quarto renders the Markdown inline, so the output reads like normal prose—not like code output. The reader never sees the `if/else`. They see a coherent paragraph that always matches the data, no matter what the data says.

This is one of Quarto's core strengths. Because code and narrative live in the same file, you can make the narrative depend on the code. A traditional workflow—run analysis in one tool, write report in another—cannot do this. The two artifacts are disconnected, and keeping them in sync is manual, error-prone work.

## The Cost of Not Doing It

Consider what happens when you skip this step. You hard-code a conclusion. Months later, someone re-renders the document with updated data. The statistical test now returns a non-significant result, but the text still says the relationship is significant. If the reader catches the contradiction, they lose trust in the entire report. If they do not catch it, they walk away with a false conclusion. Either outcome is bad, and both are preventable.

## A Habit Worth Building

The additional effort is small—an `if/else` block and a few f-strings—but the payoff compounds over time. Every document you write this way is robust to data changes by default. You stop worrying about whether your prose matches your numbers because the code guarantees it. You can hand the `.qmd` file to a collaborator, point them at a new dataset, and know that the rendered output will be internally consistent.

This is what reproducibility actually means in practice. Not just that someone *can* rerun your code and get the same numbers, but that when the numbers change, the story changes with them.

## Analysis (Highly Reproducible)

```{python}
# Describe the test
conclusion = "The Chi-squared test of independence examines relationships between two categorical variables. It produces a test statistic for evaluation. "

# RQ: Is there a relationship between day of the week and smoking status?
chi2, p_value, dof, expected = chi2_contingency(
    pd.crosstab(tips['day'], tips['smoker'])
)

if p_value < 0.05:
    conclusion += f"The results are statistically significant (p ≤ {p_value:.8f}, χ²={chi2:.4f}). We reject the null hypothesis. Given this evidene we conclude a relationship exists between day of week and smoking preference."
else:
    conclusion += f"The results are not significant (p = {p_value:.8f}, χ²={chi2:.8f}). We fail to reject the null hypothesis. Given this result we conclude we have no evidence to sho there is a relationship between day of week and smoking preference."

display(Markdown(conclusion))
```


The expected output from this reproducible code block is:

> The Chi-squared test of independence examines relationships between two categorical variables. It produces a test statistic for evaluation. The results are statistically significant (p ≤ 0.00001057, χ²=25.7872). We reject the null hypothesis. Given this evidene we conclude a relationship exists between day of week and smoking preference.

However if new data, more data, differently filtered data, went through the same code block and also produced a higher pvalue (greater than 0.05) then the output of the code would approximate the following:

> The Chi-squared test of independence examines relationships between two categorical variables. It produces a test statistic for evaluation. The results are not significant (p = 0.23990000, χ²=4.25670000). We fail to reject the null hypothesis. Given this result we conclude we have no evidence to sho there is a relationship between day of week and smoking preference.


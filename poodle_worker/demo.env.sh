# Non-secret demo settings. Source from poodle_worker/ before launching.
# Supply your existing OPENAI_API_KEY separately in the same environment.
export NOTEBOOK_GENERATION_MODEL=gpt-6-luna
export NOTEBOOK_REASONING_EFFORT=none
export NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS=20000
# Conservative standard long-context rates, USD 0.20 input / USD 0.75 output
# per million tokens. Recheck applicable account/processing rates before use.
export NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS=200000
export NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS=750000
